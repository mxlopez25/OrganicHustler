class TempUser < ApplicationRecord
  has_one :cart, as: :overall_user
  has_many :orders, as: :overall_user

end
