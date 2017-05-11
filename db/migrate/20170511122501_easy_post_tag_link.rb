class EasyPostTagLink < ActiveRecord::Migration[5.0]
  def change
    change_table :orders do |t|
      t.string :tag_link
    end
  end
end
