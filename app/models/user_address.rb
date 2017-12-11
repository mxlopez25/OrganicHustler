class UserAddress < ApplicationRecord
  belongs_to :overall_user, :polymorphic => true, optional: true
  belongs_to :order, optional: true
end
