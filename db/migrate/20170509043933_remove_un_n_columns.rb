class RemoveUnNColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :orders, :total
    remove_column :carts, :total_m
  end
end
