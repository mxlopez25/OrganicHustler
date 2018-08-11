class SubscriptionMailer < ApplicationMailer

  def new_promotion(user, subject, mail)

    @email = user
    @mail_t = mail.html_safe

    mail to: user,
         subject: subject
  end

end
