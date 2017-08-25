require 'nokogiri'
require 'typhoeus'
require 'open-uri'
require 'pry'
require 'yaml'
require 'json'
require 'date'

class ParsingError < StandardError; end

module Aerostatica

  OUTPUT_DIR = 'tmp/crawler/aerostatica'
  INDEX_LINKS_FILE = File.join(OUTPUT_DIR, 'index.yml')
  VOLUMES_DIR = File.join(OUTPUT_DIR, 'volumes')
  INDEX_URI = 'http://aerostatica.ru/all-volumes/'

  class << self
    def fetch_index

      open(INDEX_URI) do |f|
        response = f.read
        document = Nokogiri::HTML(response)

        volume_links = document.xpath('//div[@id="volumes-archives"]//div[starts-with(@id, "posts-list")]/ul//a/@href').to_a
        volume_links.map! do |link|
          URI.join(INDEX_URI, link.value).to_s
        end

        open(INDEX_LINKS_FILE, 'w') do |f|
          f << volume_links.to_yaml
        end
      end

    end

    def fetch_volumes
      hydra = Typhoeus::Hydra.new(max_concurrency: 40)

      volume_links = YAML.load_file(INDEX_LINKS_FILE)
      volume_links.each do |url|
        num = url.match(/\/(\d+-.+)\/$/)[1]
        filename = "#{num}.html"
        request = Typhoeus::Request.new(url, followlocation: true)
        request.on_complete do |result|
          open(File.join(VOLUMES_DIR, filename), 'w') do |file|
            file << result.body.force_encoding('UTF-8')

            p "#{filename} saved!"
          end
        end
        hydra.queue(request)
        p "#{filename} enqued!"
      end

      hydra.run
    end

    def scrap
      FileUtils.mkdir_p(OUTPUT_DIR)
      FileUtils.mkdir_p(VOLUMES_DIR)

      fetch_index unless File.file?(INDEX_LINKS_FILE)
      fetch_volumes
    end

    # Parsing

    def parse_episode_meta(document)
      number = document.xpath('//div[@id="blog"]//a[@class="volume-link"]').text.to_i
      raise ParsingError, "Episode number is missing" if number <= 0
      episode = Issue.find_or_initialize_by(number: number)
      return episode if episode.is_reviewed?
      episode.title  = document.xpath('/html/head/meta[@property="og:title"]/@content').text.strip
      episode.date   = Date.parse(document.xpath('//div[@id="blog"]//time/@datetime').text.strip)
      episode.source = document.xpath('/html/head/meta[@property="og:url"]/@content').text.strip

      episode
    end

    def parse_track_list(node)
      node.xpath('li/a').each do |index_node|
        track = parse_track(index_node)
        if block_given?
          yield track
        end
        track.save
      end
    end

    def parse_track(node)
      track_name = node.text
      track_name_parts = track_name.split(/(?:\s|\u{200e})+(?:-|\u{2013})(?:\s|\u{200e})+/, 2)
      artist, title = track_name_parts
      error = nil
      if track_name_parts.size > 2
        error = "Weird track name format: #{track_name}"
      elsif title.nil?
        error = "Track title is missing: #{track_name}"
      elsif artist.nil?
        error = "Track artist is missing: #{track_name}"
      end
      track = Track.find_or_initialize_by(artist: artist, title: title)

      return track if track.is_reviewed?

      track.label = "#{artist} #{title}".gsub(/[^[:alnum:]]+/, '-').gsub(/(?:^-)|(?:-$)/, '').downcase
      track.error = error unless error.nil?
      track
    end

    def parse
      volumes = Dir.glob("#{VOLUMES_DIR}/*")
      volumes[612..613].each { |file|
        return unless File.exists?(file)

        document = File.open(file) { |html| Nokogiri::HTML(html, nil, 'UTF-8') }
        # Parse episode meta information, except content
        episode = parse_episode_meta(document)
        return if episode.is_reviewed?

        # Parse episode content
        text = []
        content = document.xpath('//div[@id="main"]/article//div[@class="main-content-wrap"]/*')
        content.each { |n|
          # drop headers
          # next if n.name == "h2"
          next if n.name == 'div' && n.attribute('class').value == 'aplayer'

          case n.name
            when 'p'
              text.push(n.child.inner_html)
            when 'div'
              classname = n.attribute('class').value
              if n.attribute('class').value.include?('figure')
                # puts "oh thats picture"
              else
                puts "div but unknown: #{n.name} : #{number}"
                puts n.attribute('class')
                # puts n
              end
            when 'ul'
              # puts "Song link"
            when 'ol'
              # parse songs
              parse_track_list(n) do |track|
                episode.tracks << track
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

        episode.text = text
        episode.save
      }
    end
  end

end
