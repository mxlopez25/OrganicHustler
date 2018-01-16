class TUserTokenRequestMailer < ApplicationMailer

  def new_token_request(user, host, port)

    TempUserControl.where(temp_user_id: user.id).each do |t|
      t.destroy!
    end

    tuc = TempUserControl.new
    tuc.t_available = Time.now + 1 *60 * 60 #Temp user has a limit of 1 hour
    tuc.temp_user_id = user.id
    tuc.valid_token = true
    tuc.save!

    @token = tuc.auth_token
    @email = user.email

    mail to: user.email,
         subject: 'Review orders petition'

  end

end
