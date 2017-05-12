class AddTokenValidation < ActiveRecord::Migration[5.0]
  change_table :temp_user_controls do |t|
    t.boolean :valid_token
  end
end
