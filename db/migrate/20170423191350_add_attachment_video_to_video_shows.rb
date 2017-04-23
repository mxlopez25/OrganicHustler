class AddAttachmentVideoToVideoShows < ActiveRecord::Migration
  def self.up
    change_table :video_shows do |t|
      t.attachment :video
    end
  end

  def self.down
    remove_attachment :video_shows, :video
  end
end
