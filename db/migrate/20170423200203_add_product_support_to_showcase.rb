class AddProductSupportToShowcase < ActiveRecord::Migration[5.0]
  def change
    change_table :showcases do |t|
      t.string :product_id
      t.string :url_association
    end
  end
end
