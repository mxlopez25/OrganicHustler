class CreateTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :tickets do |t|
      t.string :temp_user_id
      t.string :subject
      t.boolean :status

      t.timestamps
    end
  end
end
