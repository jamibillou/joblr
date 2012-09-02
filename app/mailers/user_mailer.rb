class UserMailer < ActionMailer::Base
  default from: "postman@joblr.co"

  def share_profile(email_sharing,user)
  	@user = user
    @email_sharing = email_sharing
    mail to: email_sharing.recipient_email, subject: t('mailers.user.share_profile.subject', fullname: @user.fullname)
  end
end
