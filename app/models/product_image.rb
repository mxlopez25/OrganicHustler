class ProductImage < ApplicationRecord
  has_attached_file :picture, 
                    styles: {
                      big_safari: '1080x1080>',
                      big_chrome: '1080x1080>',
                      large_safari: '900x900>',
                      large_chrome: '900x900>',
                      medium_safari: '500x500>',
                      medium_chrome: '500x500>',
                      thumb_safari: '300x300>',
                      thumb_chrome: '300x300>',
                      s_thumb_safari: '120x120>',
                      s_thumb_chrome: '120x120>'
                    },
                    convert_options: {
                      big_safari: '-quality 85',
                      big_chrome: '-quality 85',
                      large_safari: '-quality 85',
                      large_chrome: '-quality 85',
                      medium_safari: '-quality 85',
                      medium_chrome: '-quality 85',
                      thumb_safari: '-quality 85',
                      thumb_chrome: '-quality 85',
                      s_thumb_safari: '-quality 85',
                      s_thumb_chrome: '-quality 85'
                  }
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\z/
  belongs_to :color
end
