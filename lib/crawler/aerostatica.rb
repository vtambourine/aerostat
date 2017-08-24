require 'nokogiri'
require 'typhoeus'
require 'open-uri'
require 'pry'
require 'yaml'
require 'json'
require 'date'

module Aerostatica

  OUTPUR_DIR = 'tmp/crawler/aerostatica'
  INDEX_LINKS_FILE = File.join(OUTPUR_DIR, 'index.yml')
  VOLUMES_DIR = File.join(OUTPUR_DIR, 'volumes')
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
      FileUtils.mkdir_p(OUTPUR_DIR)
      FileUtils.mkdir_p(VOLUMES_DIR)

      fetch_index unless File.file?(INDEX_LINKS_FILE)
      fetch_volumes
    end

    # Parsing

    Issue = Struct.new(:title, :text, :source, :number, :duration, :date)
    Track = Struct.new(:artist, :title, :label)

    def parse
      p 'Parsing'

      volumes = Dir.glob("#{VOLUMES_DIR}/*")
      volumes[614..615].each { |file|
        return unless File.exists?(file)

        document = File.open(file) { |f| Nokogiri::HTML(f, nil, 'UTF-8') }

        issue = Issue.new
        number = document.xpath('//div[@id="blog"]//a[@class="volume-link"]').text.to_i
        issue[:number] = number
        issue[:title] = document.xpath('/html/head/meta[@property="og:title"]/@content').text.strip
        datetime = document.xpath('//div[@id="blog"]//time/@datetime').text.strip
        issue[:date] = Date.parse(datetime)
        issue[:source] = document.xpath('/html/head/meta[@property="og:url"]/@content').text.strip

        content = document.xpath('//div[@id="main"]/article//div[@class="main-content-wrap"]/*')

        text = []

        tracks = []

        content.each { |n|
          # drop headers
          # next if n.name == "h2"
          next if n.name == 'div' && n.attribute('class').value == 'aplayer'

          case n.name
            when 'p'
              text.push({
                content: n.child.inner_html
              })
              # if n.child.name == 'em'
              #   # puts "It's em paragraph"
              #   text.push({
              #     node: 'em',
              #     content: n.child.inner_html
              #   })
              # elsif n.child.name == 'text'
              #   # puts "It's paragraph"
              #   text.push({
              #     node: 'p',
              #     content: n.text
              #   })
              # else
              #   puts "!!! OH WORNG PARA : #{n.child.name} : #{number}"
              # end
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
              n.xpath('li/a').each do |index_node|
                # label = index_node.attribute('href').value.sub('#', '')
                raw_name = index_node.text.split(/(?:\s|[^[:ascii:]])+(?:-|\u{2013})(?:\s|[^[:ascii:]])+/, 2)
                artist, title = raw_name

                if raw_name.size != 2
                  # binding.pry
                  puts "#{number} :: #{index_node.text} :: #{label}"
                  # puts track
                end

                # track label
                new_label = "#{artist} #{title}".gsub(/[^[:alnum:]]+/, '-').gsub(/(?:^-)|(?:-$)/, '').downcase
                # puts "#{artist} #{title}"
                # puts new_label
                #
                label = new_label

                track = Track.new(artist, title, label)
                tracks << track

              end
              # binding.pry
              # puts "Songs index"
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

        puts tracks

        # issue[:text] = document.xpath('//div[@id="main"]/article//div[@class="main-content-wrap"]')
        # puts text.to_json
      }
    end
  end

end

# Aerostatica.scrap
Aerostatica.parse
