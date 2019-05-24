class ProductImage < ApplicationRecord
  has_attached_file :picture, 
                    styles: { 
                      large: "900x900>", 
                      med: "500x500>", 
                      small: "300x300>", 
                      thumb: "120x120>" 
                    },
                    convert_options: {
                      large: '-quality 85',
                      med: '-quality 85',
                      small: '-quality 85',
                      thumb: '-quality 85'
                  }
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\z/
  belongs_to :color
end
