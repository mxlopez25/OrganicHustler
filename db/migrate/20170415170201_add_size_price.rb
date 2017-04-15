class AddSizePrice < ActiveRecord::Migration[5.0]
  def change
    change_table :cart_products do |t|
      t.string :size_leter
      t.decimal :size_price
    end
  end
end
