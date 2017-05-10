class AddPaimentIdForCustomer < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.string :c_stripe_id
    end
  end
end
