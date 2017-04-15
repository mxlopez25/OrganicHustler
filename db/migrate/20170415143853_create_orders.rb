class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.decimal :total
      t.string :state
      t.text :description

      t.timestamps
    end
  end
end
