class CustomLogo < ApplicationRecord
  belongs_to :cart_product, optional: true
  belongs_to :logo
  belongs_to :color
  belongs_to :product_image
end
