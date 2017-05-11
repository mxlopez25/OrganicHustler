class CreateTempUserControls < ActiveRecord::Migration[5.0]
  def change
    create_table :temp_user_controls do |t|
      t.string :auth_token
      t.datetime :t_available
      t.string :temp_user_id

      t.timestamps
    end
  end
end
