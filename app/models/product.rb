class Product < ApplicationRecord
  has_many :sizes
  has_many :logos
  has_many :colors
  has_many :presets
  has_many :emblems
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :styles
  has_and_belongs_to_many :materials
  has_and_belongs_to_many :brands
  has_one :tax_band
end
