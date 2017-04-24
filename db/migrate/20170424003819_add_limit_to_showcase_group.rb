class AddLimitToShowcaseGroup < ActiveRecord::Migration[5.0]
  def change
    change_table :group_showcases do |t|
      t.integer :max_count
    end
  end
end
