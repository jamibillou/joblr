class UserMailer < ActionMailer::Base
  default from: "postman@joblr.co"

  def share_profile(sharing)
    @user = User.find(sharing.user_id)
    @sharing = sharing
    mail to: sharing.email, subject: t('user_mailer.share_profile.subject', fullname: @user.fullname, role: @user.role)
  end
end
