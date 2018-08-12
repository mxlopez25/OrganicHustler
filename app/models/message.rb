class Message < ApplicationRecord
  belongs_to :ticket
  validates :data, presence: true

  after_create_commit :broadcast_message

  def broadcast_message
    MessageBroadcastJob.perform_later(self)
  end

end
