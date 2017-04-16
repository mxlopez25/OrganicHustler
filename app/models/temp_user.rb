class TempUser < ApplicationRecord
  has_one :cart, as: :overall_user

end
