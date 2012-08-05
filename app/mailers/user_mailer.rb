class UserMailer < ActionMailer::Base
  default from: "franck@engaccino.com"

  def share_profile(email,user_id)
    @user = User.find(user_id)
    mail to: email, subject: t('user_mailer.share_profile.subject', fullname: @user.fullname, role: @user.role)
  end
end
