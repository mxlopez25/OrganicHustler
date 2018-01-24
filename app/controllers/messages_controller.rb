class MessagesController < ApplicationController

  layout 'admin'

  def new
  end

  def edit
  end

  def update
    ticket_id = params['ticket_id']
    ticket = Ticket.find(ticket_id)
    ticket.status = !ticket.status
    ticket.save!

    Message.create! ({
        ticket: Ticket.find(ticket_id),
        data: 'This ticket has been terminated',
        client: false
    })

  end

  def destroy
  end

  def create
    ticket_id = params['ticket_id']
    data = params['data']
    client = params['client']
    t = Ticket.find(ticket_id)

    Message.create! ({
        ticket: t,
        data: data,
        client: client
    })

    TransactionalMailer.support_message(t).deliver_now

  end

end
