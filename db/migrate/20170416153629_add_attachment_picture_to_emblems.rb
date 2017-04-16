class AddAttachmentPictureToEmblems < ActiveRecord::Migration
  def self.up
    change_table :emblems do |t|
      t.attachment :picture
      t.decimal :pos_1_x
      t.decimal :pos_1_y
      t.decimal :pos_2_x
      t.decimal :pos_2_y
      t.decimal :pos_3_x
      t.decimal :pos_3_y
      t.decimal :pos_4_x
      t.decimal :pos_4_y
      t.decimal :emblem_cost
      t.decimal :width
      t.decimal :height
      t.decimal :rel_x
      t.decimal :rel_y
    end
  end

  def self.down
    remove_attachment :emblems, :picture
  end
end
