class ProductImage < ApplicationRecord
  has_attached_file :picture, styles: {medium: "500x500>", thumb: "300x300>", large: "800x800>", s_thumb: "120x120>"}, default_url: "/images/no-logo.jpg"
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\z/
  belongs_to :color
end
