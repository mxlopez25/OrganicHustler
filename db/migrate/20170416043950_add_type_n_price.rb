class AddTypeNPrice < ActiveRecord::Migration[5.0]
  def change
    change_table :pictures do |t|
      t.string :type
      t.decimal :price
    end
  end
end
