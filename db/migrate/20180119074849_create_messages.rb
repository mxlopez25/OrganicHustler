class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.string :ticket_it
      t.text :data
      t.boolean :client

      t.timestamps
    end
  end
end
