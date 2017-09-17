class Preset < ApplicationRecord
  has_one :logo
  has_one :color
  belongs_to :product

end
