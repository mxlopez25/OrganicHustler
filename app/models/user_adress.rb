class UserAdress < ApplicationRecord
  belongs_to :overall_user, :polymorphic => true, optional: true
end
