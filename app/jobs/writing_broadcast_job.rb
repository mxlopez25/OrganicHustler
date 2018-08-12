class WritingBroadcastJob < ApplicationJob
  queue_as :default

  def perform(ticket, sender)
    ActionCable.server.broadcast "room-#{ticket}:chat_channel", writing: sender
  end
end