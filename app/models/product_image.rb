class ProductImage < ApplicationRecord
  has_attached_file :picture, 
                    styles: { 
                      thumb: ["120x120>", :webp], 
                      small: ["300x300>", :webp], 
                      med: ["500x500>", :webp], 
                      large: ["900x900>", :webp], 
                      big: ["1080x1080>", :webp], 
                      huge: ["1980x1980>", :webp] 
                    },
                    convert_options: {
                      thumb: '-quality 85',
                      small: '-quality 85',
                      med: '-quality 85',
                      large: '-quality 85',
                      big: '-quality 85',
                      huge: '-quality 85'
                  }
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\z/
  belongs_to :color
end
