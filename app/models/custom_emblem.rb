class CustomEmblem < ApplicationRecord
  belongs_to :cart_product
  has_one :position_emblem_admin
  has_one :color
  has_one :product_image
end
