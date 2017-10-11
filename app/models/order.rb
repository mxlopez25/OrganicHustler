class Order < ApplicationRecord
  has_one :cart
  has_one :promotion_code
  has_one :user_address
  belongs_to :overall_user, :polymorphic => true

end
