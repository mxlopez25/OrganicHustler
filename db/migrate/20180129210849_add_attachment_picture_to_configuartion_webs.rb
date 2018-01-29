class AddAttachmentPictureToConfiguartionWebs < ActiveRecord::Migration
  def self.up
    change_table :configuration_webs do |t|
      t.attachment :picture
    end
  end

  def self.down
    remove_attachment :configuration_webs, :picture
  end
end
