class Volume < ApplicationRecord
  has_and_belongs_to_many :tracks
  has_many :artists, :through => :tracks

  def permalink
    # volume_url(self)
  end
end
