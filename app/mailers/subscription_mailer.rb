class SubscriptionMailer < ApplicationMailer

  def new_promotion(user, subject, mail)

    @mail_t = mail.html_safe

    mail bcc: user,
         subject: subject
  end

end
