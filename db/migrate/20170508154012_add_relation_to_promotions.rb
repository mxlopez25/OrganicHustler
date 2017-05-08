class AddRelationToPromotions < ActiveRecord::Migration[5.0]
  def change
    change_table :promotion_codes do |t|
      t.string :order_id
    end
  end
end
