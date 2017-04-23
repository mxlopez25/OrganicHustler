class CreateShowcases < ActiveRecord::Migration[5.0]
  def change
    create_table :showcases do |t|
      t.boolean :screen
      t.boolean :active

      t.timestamps
    end
  end
end
