class AddRelationGallery < ActiveRecord::Migration[5.0]
  def change
    change_table :galleries do |t|
      t.string :product_id
    end
  end
end
