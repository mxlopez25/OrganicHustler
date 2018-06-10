class AddMethodsToHistory < ActiveRecord::Migration[5.0]
  def change
    change_table :histories do |t|
      t.string :source_ip
      t.string :method
      t.string :json_data
    end
  end
end
