class SetupRelationsOrders < ActiveRecord::Migration[5.0]
  def change
    change_table :carts do |t|
      t.string :order_id
    end

    change_table :orders do |t|
      t.string :overall_user_id
      t.string :overall_user_type
    end

  end
end
