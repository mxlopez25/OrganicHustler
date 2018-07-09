class ProductImage < ApplicationRecord
  has_attached_file :picture, processors: [:web_p], styles: {
    medium: { format: :webp, size: 500 },
    thumb: { format: :webp, size: 300 },
    large: { format: :webp, size: 900 },
    s_thumb: { format: :webp, size: 120 },
    big: { format: :webp, size: 1080 }
  }, default_url: "/images/no-logo.jpg"
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\z/
  belongs_to :color
end
