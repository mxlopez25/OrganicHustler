class CartsGifts < ActiveRecord::Migration[5.0]
  def change
    create_table :carts_gifts do |t|
      t.string :cart_id
      t.string :gift_id
    end
  end
end
