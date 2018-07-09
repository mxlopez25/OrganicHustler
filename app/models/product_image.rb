class ProductImage < ApplicationRecord
  has_attached_file :picture, styles: {
      medium: ["500x500>", { lossless: true, format: :webp }],
      thumb: ["300x300>", { lossless: true, format: :webp }],
      large: ["800x800>", { lossless: true, format: :webp }],
      s_thumb: ["120x120>", { lossless: true, format: :webp }]
  },
                    default_url: "/images/no-logo.jpg"
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\z/
  belongs_to :color
end
