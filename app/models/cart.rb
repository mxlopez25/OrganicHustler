class Cart < ApplicationRecord
  has_many :cart_products, dependent: :destroy
  belongs_to :overall_user, :polymorphic => true, optional: true
  belongs_to :order, optional: true
end
