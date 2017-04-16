class AddRequiredColumnsForRelations < ActiveRecord::Migration[5.0]
  def change
    change_table :carts do |t|
      t.integer :temp_user_id
    end
  end
end
