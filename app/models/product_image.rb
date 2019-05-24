class ProductImage < ApplicationRecord
  has_attached_file :picture, 
                    styles: { 
                      thumb: ["64x64#", :webp], 
                      small: ["100x100#", :webp], 
                      med: ["150x150>", :webp], 
                      large: ["200x200>", :webp] 
                    },
                    convert_options: {
                      thumb: '-quality 85',
                      small: '-quality 85',
                      med: '-quality 85',
                      large: '-quality 85'
                  }
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\z/
  belongs_to :color
end
