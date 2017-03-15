class AddColumnToPicture < ActiveRecord::Migration
  def self.up
    change_table :pictures do |t|
      t.integer :gallery_id
    end
  end

end
