class CreateChangeAuthors < ActiveRecord::Migration[5.0]
  def change
    create_table :change_authors do |t|
      t.string :email
      t.string :code_authenticity
      t.boolean :used
      t.datetime :limit

      t.timestamps
    end
  end
end
