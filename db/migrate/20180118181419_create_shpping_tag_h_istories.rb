class CreateShppingTagHIstories < ActiveRecord::Migration[5.0]
  def change
    create_table :shipping_tag_histories do |t|
      t.string :order_id
      t.string :easy_post_id

      t.timestamps
    end
  end
end
