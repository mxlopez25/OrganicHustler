class AddEmblemData < ActiveRecord::Migration[5.0]
  def change
    change_table :cart_products do |t|
      t.integer :position_e_x
      t.integer :position_e_y

    end
  end
end
