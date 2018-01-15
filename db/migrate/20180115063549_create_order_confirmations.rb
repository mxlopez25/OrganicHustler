class CreateOrderConfirmations < ActiveRecord::Migration[5.0]
  def change
    create_table :order_confirmations do |t|
      t.string :confirmation_token
      t.boolean :used
      t.datetime :limit
      t.string :order_id

      t.timestamps
    end
  end
end
