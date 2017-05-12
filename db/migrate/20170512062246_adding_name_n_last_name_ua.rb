class AddingNameNLastNameUa < ActiveRecord::Migration[5.0]
  def change
    change_table :user_addresses do |t|
      t.string :name
      t.string :last_name
    end
  end
end
