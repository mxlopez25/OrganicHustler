class CustomEmblem < ApplicationRecord
  belongs_to :cart_product, optional: true
  belongs_to :position_emblem_admin
  belongs_to :color
  belongs_to :product_image
end
