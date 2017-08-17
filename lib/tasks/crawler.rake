namespace :crawler do
  task scrap: :environment do
    Crawler.scrap
  end
end
