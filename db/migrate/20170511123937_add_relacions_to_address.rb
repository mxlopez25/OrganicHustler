class AddRelacionsToAddress < ActiveRecord::Migration[5.0]
  def change
    change_table :user_addresses do |t|
      t.string :order_id
      t.string :overall_user_id
      t.string :overall_user_type
    end
  end
end
