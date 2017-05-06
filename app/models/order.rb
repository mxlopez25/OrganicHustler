class Order < ApplicationRecord
  has_one :cart
  belongs_to :overall_user, :polymorphic => true

end
