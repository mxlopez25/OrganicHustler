class SubscriptionMailer < ApplicationMailer

  def new_promotion(user, subject, mail)

    @mail_t = mail.html_safe

    mail to: user,
         subject: subject
  end

end
