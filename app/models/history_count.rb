class HistoryCount < ApplicationRecord
  belongs_to :owner, polymorphic: true
end
