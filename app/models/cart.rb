class Cart < ApplicationRecord
  has_many :cart_products, dependent: :destroy
  belongs_to :overall_user, :polymorphic => true, optional: true
  belongs_to :order, optional: true
  has_and_belongs_to_many :promotion_codes
  has_and_belongs_to_many :gifts
end
