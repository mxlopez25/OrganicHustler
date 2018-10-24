class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room-#{decrypt(params['room'])}:chat_channel"
  end

  def unsubscribed
  end

  def decrypt text
    salt, data = text.split "$$"

    len   = ActiveSupport::MessageEncryptor.key_len
    key   = ActiveSupport::KeyGenerator.new(Rails.application.secrets.secret_key_base).generate_key salt, len
    crypt = ActiveSupport::MessageEncryptor.new key
    crypt.decrypt_and_verify data
  end

  def send_message(data)
    Message.create(
      data: data['message'],
      ticket_id: decrypt(data['ticket']),
      client: data['sender']
    )
  end

  def send_writing(data)
    ticket = decrypt(data['ticket'])
    WritingBroadcastJob.perform_now(ticket, data['sender'])
  end

end
