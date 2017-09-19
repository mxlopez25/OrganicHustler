class Color < ApplicationRecord
  has_many :product_images
  belongs_to :product, optional: true
end
