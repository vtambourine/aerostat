require_relative '../crawler/aerostatica'
require 'pry'

namespace :crawler do
  task scrap: :environment do
    # Crawler::scrap
  end

  task parse: :environment do
    # binding.pry
    Aerostatica.parse
  end

end
