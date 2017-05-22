class AddingEmblemSize < ActiveRecord::Migration[5.0]
  def change
    change_table :position_emblem_admins do |t|
      t.decimal :width, :scale => 2
      t.decimal :height, :scale => 2
    end
  end
end
