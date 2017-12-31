class CreateGifts < ActiveRecord::Migration[5.0]
  def change
    create_table :gifts do |t|
      t.decimal :rate
      t.string :code
      t.integer :limit_usage
      t.datetime :time_available
      t.boolean :used

      t.timestamps
    end
  end
end
