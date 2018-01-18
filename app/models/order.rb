class Order < ApplicationRecord
  has_one :cart
  has_one :user_address
  has_many :shipping_tag_histories
  belongs_to :overall_user, :polymorphic => true

end
