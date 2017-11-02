class CartProduct < ApplicationRecord
  belongs_to :cart, optional: true
  has_many :custom_logos
  has_many :custom_emblems
end
