class EmplemRelationWProM < ActiveRecord::Migration[5.0]
  def change
    change_table :emblems do |t|
      t.string :id_moltin
    end
  end
end
