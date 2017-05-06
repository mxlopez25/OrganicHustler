class CreateUserAdresses < ActiveRecord::Migration[5.0]
  def change
    create_table :user_adresses do |t|
      t.string :user_id
      t.string :street_address
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :area
      t.string :number

      t.timestamps
    end
  end
end
