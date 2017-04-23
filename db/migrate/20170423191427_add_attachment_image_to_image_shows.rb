class AddAttachmentImageToImageShows < ActiveRecord::Migration
  def self.up
    change_table :image_shows do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :image_shows, :image
  end
end
