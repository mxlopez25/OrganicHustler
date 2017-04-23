class CreateImageShows < ActiveRecord::Migration[5.0]
  def change
    create_table :image_shows do |t|

      t.timestamps
    end
  end
end
