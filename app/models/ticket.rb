class Ticket < ApplicationRecord
  has_many :messages
  belongs_to :temp_user
end
