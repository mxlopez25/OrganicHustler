class CreateMailContents < ActiveRecord::Migration[5.0]
  def change
    create_table :mail_contents do |t|
      t.text :content
      t.string :subject

      t.timestamps
    end
  end
end
