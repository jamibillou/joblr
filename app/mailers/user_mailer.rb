class UserMailer < ActionMailer::Base
  default from: "postman@joblr.co"

  def share_profile(sharing)
    @user = User.find(sharing.author_id)
    @sharing = sharing
    mail to: sharing.recipient.email, subject: t('user_mailer.share_profile.subject', fullname: @user.fullname, role: @user.role)
  end
end
