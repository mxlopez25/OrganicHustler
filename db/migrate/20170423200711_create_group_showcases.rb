class CreateGroupShowcases < ActiveRecord::Migration[5.0]
  def change
    create_table :group_showcases do |t|
      t.text :name_identity
      t.integer :screen

      t.timestamps
    end

    change_table :showcases do |t|
      t.integer :group_showcase_id
    end

  end
end
