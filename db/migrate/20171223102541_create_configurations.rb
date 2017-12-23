class CreateConfigurations < ActiveRecord::Migration[5.0]
  def change
    create_table :configuration_webs do |t|
      t.string :title
      t.text :value
      t.integer :content_type

      t.timestamps
    end
  end
end
