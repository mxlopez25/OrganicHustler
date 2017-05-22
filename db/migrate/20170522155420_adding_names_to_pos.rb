class AddingNamesToPos < ActiveRecord::Migration[5.0]
  def change
    change_table :position_emblem_admins do |t|
      t.string :name
    end
  end
end
