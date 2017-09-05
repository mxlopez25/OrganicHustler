class Preset < ApplicationRecord
  has_one :logo
  belongs_to :product
end
