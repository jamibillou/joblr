class EmailSharingMailer < ActionMailer::Base
  default from: "postman@joblr.co"

  def user(email_sharing, user)
  	@user = user
    @email_sharing = email_sharing
    mail to: email_sharing.recipient_email, subject: t('mailers.email_sharing.user.subject', fullname: @user.fullname)
  end

  def other_user(email_sharing, user)
    @user = user
    @email_sharing = email_sharing
    mail to: email_sharing.recipient_email, subject: t('mailers.email_sharing.other_user.subject', fullname: current_user.fullname)
  end

  def public_user(email_sharing, user)
    @user = user
    @email_sharing = email_sharing
    mail to: email_sharing.recipient_email, subject: t('mailers.email_sharing.public_user.subject', fullname: @email_sharing.author_fullname)
  end
end
