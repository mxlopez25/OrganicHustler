class CreatePormotionCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :pormotion_codes do |t|
      t.decimal :rate
      t.string :code
      t.datetime :timeAv

      t.timestamps
    end
  end
end
