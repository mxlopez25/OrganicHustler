class CreatePositionEmblemAdmins < ActiveRecord::Migration[5.0]
  def change
    create_table :position_emblem_admins do |t|
      t.decimal :x
      t.decimal :y
      t.decimal :rel_x
      t.decimal :rel_y
      t.string :emblem_id
      t.decimal :cost

      t.timestamps
    end

    remove_column :emblems, :pos_1_x
    remove_column :emblems, :pos_1_y
    remove_column :emblems, :pos_2_x
    remove_column :emblems, :pos_2_y
    remove_column :emblems, :pos_3_x
    remove_column :emblems, :pos_3_y
    remove_column :emblems, :pos_4_x
    remove_column :emblems, :pos_4_y

  end
end
