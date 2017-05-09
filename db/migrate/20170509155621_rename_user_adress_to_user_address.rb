class RenameUserAdressToUserAddress < ActiveRecord::Migration[5.0]
  def change
    rename_table :user_adresses, :user_addresses
  end
end
