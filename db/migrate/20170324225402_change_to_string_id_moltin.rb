class ChangeToStringIdMoltin < ActiveRecord::Migration[5.0]
  def self.up
    change_table :users do |t|
      t.string :id_moltin
    end
  end
end
