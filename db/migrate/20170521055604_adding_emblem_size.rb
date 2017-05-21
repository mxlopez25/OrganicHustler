class AddingEmblemSize < ActiveRecord::Migration[5.0]
  def change
    change_table :position_emblem_admins do |t|
      t.decimal :width
      t.decimal :height
    end
  end
end
