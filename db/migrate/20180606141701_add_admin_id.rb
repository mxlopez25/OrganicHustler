class AddAdminId < ActiveRecord::Migration[5.0]
  def change
    change_table :histories do |t|
      t.string :admin_id
    end
  end
end
