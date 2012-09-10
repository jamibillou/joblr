class UserMailer < ActionMailer::Base
  default from: "postman@joblr.co"

  def share_profile(email_sharing, user)
  	@user = user
    @email_sharing = email_sharing
    mail to: email_sharing.recipient_email, subject: t('mailers.user.share_profile.subject', fullname: @user.fullname)
  end

  class Preview < MailView

    def share_profile
      user          = FactoryGirl.create :user, fullname: FactoryGirl.generate(:fullname), username: FactoryGirl.generate(:username), email: FactoryGirl.generate(:email)
      profile       = FactoryGirl.create :profile, user: user
      email_sharing = FactoryGirl.create :email_sharing, author: user, profile: profile
      email = UserMailer.share_profile email_sharing, user
      email
    end
  end
end
