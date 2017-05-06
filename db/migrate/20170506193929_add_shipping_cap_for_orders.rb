class AddShippingCapForOrders < ActiveRecord::Migration[5.0]
  def change
    change_table :orders do |t|
      t.string :carrier
      t.string :tracking_code
    end
  end
end
