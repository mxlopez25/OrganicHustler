class CreateCartProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :cart_products do |t|
      t.string :m_id
      t.string :logo_id
      t.decimal :dim_x
      t.decimal :dim_y
      t.decimal :relation_x
      t.decimal :relation_y
      t.decimal :width
      t.decimal :height
      t.decimal :total_m
      t.boolean :has_logo
      t.boolean :has_emblem
      t.string :emblem_id

      t.timestamps
    end
  end
end
