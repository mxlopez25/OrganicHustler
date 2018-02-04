class MailContentsController < ApplicationController

  def update
    mail_c = MailContent.find params[:mail_id]
    mail_c.subject = params['subject']
    mail_c.content = params['content']
    render json: mail_c.save!, status: :ok
  end

end