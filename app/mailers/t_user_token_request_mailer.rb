class TUserTokenRequestMailer < ApplicationMailer

  def new_token_request(user)

    TempUserControl.where(temp_user_id: user.id).each do |t|
      t.destroy!
    end

    tuc = TempUserControl.new
    tuc.t_available = Time.now + 2 *60 * 60 #Temp user has a limit of 2 hours
    tuc.temp_user_id = user.id
    tuc.save!

    @token = tuc.auth_token

    mail to: user.email,
         subject: 'Review orders petition'

  end

end
