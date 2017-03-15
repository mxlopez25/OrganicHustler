class AddColumnsToRelation < ActiveRecord::Migration[5.0]
  def change
    change_table :relation_logos do |t|
      t.float   :left_margin
      t.float   :top_margin
      t.float   :right_margin
      t.float   :bottom_margin
    end
  end
end
