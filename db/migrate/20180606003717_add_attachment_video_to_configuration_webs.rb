class AddAttachmentVideoToConfigurationWebs < ActiveRecord::Migration[5.0]
  def self.up
    change_table :configuration_webs do |t|
      t.attachment :video
    end
  end

  def self.down
    remove_attachment :configuration_webs, :video
  end
end
