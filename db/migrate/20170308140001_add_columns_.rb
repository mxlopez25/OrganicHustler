class AddColumns < ActiveRecord::Migration[5.0]
  def self.up
    change_table :users do |t|
      t.string :user_name,      null: false, default: ""
      t.string :user_last_name, null: false, default: ""
    end
  end
end
