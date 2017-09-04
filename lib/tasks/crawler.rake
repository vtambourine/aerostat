require_relative '../crawler/aerostatica'

namespace :crawler do
  task scrap: :environment do
    Aerostatica.scrap
  end

  task parse: :environment do
    Aerostatica.parse
  end

end
