class AddingAdressToOrders < ActiveRecord::Migration[5.0]
  def change
    change_table :orders do |t|
      t.string :user_address_id
    end
  end
end
