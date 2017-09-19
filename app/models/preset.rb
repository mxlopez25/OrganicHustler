class Preset < ApplicationRecord
  has_one :logo
  has_one :color
  belongs_to :product

  def logo
    Logo.find self.logo_id
  end

  def color_image
    (Color.find self.color_id).product_images.where(main: true).first
  end

end
