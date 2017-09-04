class Track < ApplicationRecord
  has_and_belongs_to_many :issues
  belongs_to :artist
end
