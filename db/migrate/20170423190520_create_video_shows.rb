class CreateVideoShows < ActiveRecord::Migration[5.0]
  def change
    create_table :video_shows do |t|

      t.timestamps
    end
  end
end
