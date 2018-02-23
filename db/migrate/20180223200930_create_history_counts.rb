class CreateHistoryCounts < ActiveRecord::Migration[5.0]
  def change
    create_table :history_counts do |t|
      t.string :owner_type
      t.string :owner_id

      t.timestamps
    end
  end
end
