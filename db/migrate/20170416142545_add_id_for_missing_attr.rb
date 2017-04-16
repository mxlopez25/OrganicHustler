class AddIdForMissingAttr < ActiveRecord::Migration[5.0]
  def change
    change_table :cart_products do |t|
      t.integer :cart_id
    end
  end
end
