require_relative '../crawler/crawler'

namespace :crawler do
  task scrap: :environment do
    Crawler::scrap
  end
end
