class TicketsController < ApplicationController

  layout 'admin'

  def new
  end

  def edit
  end

  def update

  end

  def destroy
  end

  def create
    temp_user_id = params['temp_user_id']
    subject = params['subject']
    status = params['status']

    Ticket.create! ({
        temp_user: TempUser.find(temp_user_id),
                       subject: subject,
                       status: status
                   })

    #send mail of open ticket

  end

end
