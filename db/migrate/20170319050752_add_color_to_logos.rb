class AddColorToLogos < ActiveRecord::Migration[5.0]
  def self.up
    change_table :pictures do |t|
      t.string :color
    end
  end
end
