class AddAttachmentPictureToCartProducts < ActiveRecord::Migration
  def self.up
    change_table :cart_products do |t|
      t.attachment :picture
    end
  end

  def self.down
    remove_attachment :cart_products, :picture
  end
end
