class Color < ApplicationRecord
  has_many :product_images, dependent: :destroy
  belongs_to :product, optional: true

  def main_photo
    self.product_images.where(main: true).first
  end

  def change_main_photo(new_id)
    main_photo = self.main_photo
    if main_photo
      main_photo.main = false
      main_photo.save!
    end

    new_main = ProductImage.find new_id
    new_main.main = true
    new_main.save!

    product = self.product
    product.product_image_id = new_main.picture
    product.save!
  end
end
