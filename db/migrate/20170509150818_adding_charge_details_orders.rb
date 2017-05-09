class AddingChargeDetailsOrders < ActiveRecord::Migration[5.0]
  def change
    change_table :orders do |t|
      t.string :charge_id
    end
  end
end
