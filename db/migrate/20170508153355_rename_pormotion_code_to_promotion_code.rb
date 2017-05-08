class RenamePormotionCodeToPromotionCode < ActiveRecord::Migration[5.0]
  def change
    rename_table :pormotion_codes, :promotion_codes
  end
end
