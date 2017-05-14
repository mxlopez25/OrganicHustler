class AddCaptionToShowcase < ActiveRecord::Migration[5.0]
  def change
    change_table :showcases do |t|
      t.string :caption
    end
  end
end
