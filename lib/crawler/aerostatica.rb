require 'nokogiri'
require 'typhoeus'
require 'open-uri'
require 'pry'
require 'yaml'
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

    def parse
      p 'Parsing'

      volumes = Dir.glob("#{VOLUMES_DIR}/*")
      volumes.sample(2).each { |file|
        return unless File.exists?(file)

        document = File.open(file) { |f| Nokogiri::HTML(f, nil, 'UTF-8') }

        issue = Issue.new
        issue[:number] = document.xpath('//div[@id="blog"]//a[@class="volume-link"]').text.to_i
        issue[:title] = document.xpath('/html/head/meta[@property="og:title"]/@content').text.strip
        datetime = document.xpath('//div[@id="blog"]//time/@datetime').text.strip
        issue[:date] = Date.parse(datetime)
        issue[:source] = document.xpath('/html/head/meta[@property="og:url"]/@content').text.strip

        # issue[:text] = document.xpath('//div[@id="main"]/article//div[@class="main-content-wrap"]')
        puts issue
        # binding.pry
      }
    end
  end

end

# Aerostatica.scrap
Aerostatica.parse
