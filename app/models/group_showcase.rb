class GroupShowcase < ApplicationRecord
  has_many :showcases, dependent: :destroy


end
