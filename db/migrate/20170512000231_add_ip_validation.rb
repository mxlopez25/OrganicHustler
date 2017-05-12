class AddIpValidation < ActiveRecord::Migration[5.0]
  def change
    change_table :temp_user_controls do |t|
      t.string :ip_address
    end
  end
end
