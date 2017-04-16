class AddRequiredColumnsForRelations < ActiveRecord::Migration[5.0]
  def change
    change_table :carts do |t|
      t.integer :overall_user_id
      t.string :overall_user_type
    end
  end
end
