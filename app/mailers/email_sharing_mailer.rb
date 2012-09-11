class EmailSharingMailer < ActionMailer::Base

  default from: "postman@joblr.co"
  layout 'mailers', only: :decline

  def share_profile(email_sharing, user)
  	@user = user
    @email_sharing = email_sharing
    mail to: email_sharing.recipient_email, subject: t('mailers.email_sharing.share_profile.subject', fullname: @user.fullname)
  end

  def decline(email_sharing)
    @subject     = t('mailers.email_sharing.decline.subject')
    @title       = t('mailers.email_sharing.decline.title')
    @email_sharing = email_sharing
  	mail to: email_sharing.email, subject: t('mailers.email_sharing.decline.subject', fullname: @email_sharing.recipient_fullname) 
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

    def decline
      name          = Faker::Name.name
      user          = FactoryGirl.create :user, fullname: name, username: name.parameterize, email: "#{name.parameterize}@example.com"
      profile       = FactoryGirl.create :profile, user: user
      email_sharing = FactoryGirl.create :email_sharing, author: user, profile: profile
      email         = EmailSharingMailer.decline email_sharing
      email      
    end
  end
end
