class CreateRelationForShowcase < ActiveRecord::Migration[5.0]
  def change
    change_table :showcases do |t|
      t.integer :video_show_id
      t.integer :image_show_id
    end

    change_table :video_shows do |t|
      t.integer :showcase_id
    end

    change_table :image_shows do |t|
      t.integer :showcase_id
    end

  end
end
