class AddEmblemData < ActiveRecord::Migration[5.0]
  def change
    change_table :cart_products do |t|
      t.integer :position_id

    end
  end
end
