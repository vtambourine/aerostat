require 'pp'
require 'nokogiri'
require 'typhoeus'
require 'open-uri'
require 'pry'
require 'yaml'
require 'json'
require 'date'
require 'digest/md5'

class ParsingError < StandardError; end

module Aerostatica

  OUTPUT_DIR = 'tmp/crawler/aerostatica'
  INDEX_LINKS_FILE = File.join(OUTPUT_DIR, 'index.yml')
  VOLUMES_DIR = File.join(OUTPUT_DIR, 'volumes')
  INDEX_URI = 'http://aerostatica.ru/all-volumes/'

  class << self
    def fetch_index
      open(INDEX_URI) do |page|
        response = page.read
        document = Nokogiri::HTML(response)

        volume_links = document.xpath('//div[@id="volumes-archives"]//div[starts-with(@id, "posts-list")]/ul//a/@href').to_a
        volume_links.map! do |link|
          URI.join(INDEX_URI, link.value).to_s
        end

        open(INDEX_LINKS_FILE, 'w') do |file|
          file << volume_links.reverse.to_yaml
        end
      end
    end

    def fetch_volumes(force = false)
      hydra = Typhoeus::Hydra.new(max_concurrency: 40)

      volume_links = YAML.load_file(INDEX_LINKS_FILE)
      volume_links.each do |url|
        num = url.match(/\/(\d+-.+)\/$/)[1]
        filename = "#{num}.html"
        file = File.join(VOLUMES_DIR, filename)

        next if !force and File.file?(file)

        request = Typhoeus::Request.new(url, followlocation: true)
        request.on_complete do |result|
          open(file, 'w') do |file|
            file << result.body.force_encoding('UTF-8')
            p "#{filename} saved!"
          end
        end
        hydra.queue(request)
        p "#{filename} enqued!"
      end

      hydra.run
    end

    #
    # Scrap volume pages
    #
    def scrap
      FileUtils.mkdir_p(OUTPUT_DIR)
      FileUtils.mkdir_p(VOLUMES_DIR)

      # fetch_index unless File.file?(INDEX_LINKS_FILE)
      fetch_index
      fetch_volumes
    end

    # Parsing

    def parse_track(node)
      track_name = node.text
      track_name_parts = track_name.split(/(?:\s|\u{200e})+(?:-|\u{2013})(?:\s|\u{200e})+/, 2)
      raw_artist, title = track_name_parts
      error = nil
      if track_name_parts.size > 2
        error = "Weird track name format: #{track_name}"
      elsif title.nil?
        error = "Track title is missing: #{track_name}"
      elsif raw_artist.nil?
        error = "Track artist is missing: #{track_name}"
      end

      artist_name_hash = Digest::MD5.hexdigest(raw_artist || '')
      artist = Artist.find_or_initialize_by(name_hash: artist_name_hash)
      unless artist.is_reviewed
        artist.name = raw_artist
        artist.raw_name = raw_artist
      end

      track_title_hash = Digest::MD5.hexdigest(title || '')
      track = Track.find_or_initialize_by(title_hash: track_title_hash)
      unless track.is_reviewed
        track.title = title
        track.raw_title = title
        track.artist = artist
        track.label = "#{raw_artist} #{title}".gsub(/[^[:alnum:]]+/, '-').gsub(/(?:^-)|(?:-$)/, '').downcase
        track.error = error unless error.nil?
      end

      track
    end

    #
    # Parse volume pages
    #
    def parse
      volumes = Dir.glob("#{VOLUMES_DIR}/*")
      volumes[300..613].each do |file|
        document = File.open(file) { |html| Nokogiri::HTML(html, nil, 'UTF-8') }

        number = document.xpath('//div[@id="blog"]//a[@class="volume-link"]').text.to_i
        raise ParsingError, "Episode number is missing" if number <= 0

        episode = Volume.find_or_initialize_by(id: number)
        return episode if episode.is_reviewed?

        episode.number = number

        title_node = document.xpath('/html/head/meta[@property="og:title"]/@content')
        episode.title = title_node.text.strip
        episode.raw_title = episode.title

        date_node = document.xpath('//div[@id="blog"]//time/@datetime')
        episode.published_at = Date.parse(date_node.text.strip)

        aerostatica_url_node = document.xpath('/html/head/meta[@property="og:url"]/@content')
        episode.aerostatica_url = aerostatica_url_node.text.strip

        aquarium_url_node = document.xpath('//div[@class="post-meta"]/span/a/@href')
        episode.aquarium_url = aquarium_url_node.text.strip

        # Parse episode content
        text = []
        volume_tracks = []
        intext_track_number = 0
        content = document.xpath('//div[@id="main"]/article//div[@class="main-content-wrap"]/*')
        content.each { |n|
          # drop headers
          # next if n.name == "h2"
          next if n.name == 'div' && n.attribute('class').value == 'aplayer'

          case n.name
            when 'p'
              text.push(
                tag: n.name,
                content: n.inner_html
              )
            when 'div'
              classname = n.attribute('class').value
              if n.attribute('class').value.include?('figure')
                # puts "oh thats picture"
                image_node = n.xpath('img')
                text.push(
                  tag: :image,
                  caption: image_node.xpath('@alt').text,
                  source: image_node.xpath('@src').text
                )
              else
                puts "div but unknown: #{n.name} : #{number}"
                puts n.attribute('class')
                # puts n
              end
            when 'ul'
              # puts "Song link"
              list_node = n.search('li/h4/text()')
              if list_node.empty?
                text.push(
                  tag: :list,
                  content: n.inner_html
                )
              else
                track_order = volume_tracks[intext_track_number]
                text.push(
                  tag: :track,
                  content: list_node.text.strip,
                  id: track_order.id
                )
                intext_track_number += 1
              end
              # p "#{intext_track_number} - #{n.xpath('li/h4/text()').text.strip}"
              # p track_order.id
              # binding.pry
            when 'ol'
              # parse songs
              n.xpath('li/a').each do |index_node|
                track = parse_track(index_node)
                track.save
                unless episode.tracks.find_by_id(track.id)
                  episode.tracks << track
                end
                volume_tracks << track
              end

            when 'h2'
              # skip hr
              next
            when 'hr'
              # skip hr
              next
            else
              puts "!!! SOMETHING GOES WRONG : #{n.name} : #{number}"
          end
        }

        # binding.pry
        # pp text
        episode.text = text.to_json
        episode.save

        p "Volume #{file} parsed!"
      end
    end
  end

end
