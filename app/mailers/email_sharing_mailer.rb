class EmailSharingMailer < ActionMailer::Base
  default from: "postman@joblr.co"

  def share_profile(email_sharing, user)
  	@user = user
    @email_sharing = email_sharing
    mail to: email_sharing.recipient_email, subject: t('mailers.user.share_profile.subject', fullname: @user.fullname)
  end

  def decline_status(email_sharing)
  	##To be completed
  end

  def decline_reason(email_sharing)
  	##To be completed
  end

  class Preview < MailView

    def share_profile
      name          = Faker::Name.name
      user          = FactoryGirl.create :user, fullname: name, username: name.parameterize, email: "#{name.parameterize}@example.com"
      profile       = FactoryGirl.create :profile, user: user
      email_sharing = FactoryGirl.create :email_sharing, author: user, profile: profile
      email         = EmailSharingMailer.share_profile email_sharing, user
      email
    end
  end
end
