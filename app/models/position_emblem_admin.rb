class PositionEmblemAdmin < ApplicationRecord
  has_one :product_image
  has_attached_file :picture, styles: {medium: "300x300>", thumb: "100x100>"}, default_url: "/images/no-logo.jpg"
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\z/

  def color_image
    (Color.find self.color_id).product_images.where(main: true).first
  end

end
