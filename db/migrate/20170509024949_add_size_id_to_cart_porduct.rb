class AddSizeIdToCartPorduct < ActiveRecord::Migration[5.0]
  def change
    change_table :cart_products do |t|
      t.string :size_id
    end

    remove_column :cart_products, :size_leter
    remove_column :cart_products, :size_price
    remove_column :cart_products, :total_m

  end
end
