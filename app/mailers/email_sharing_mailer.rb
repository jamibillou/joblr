class EmailSharingMailer < ActionMailer::Base
  default from: "postman@joblr.co"

  def user(email_sharing, user)
  	@user = user
    @email_sharing = email_sharing
    mail to: email_sharing.recipient_email, subject: t('mailers.email_sharing.user.subject', fullname: @user.fullname)
  end

  def other_user(email_sharing, user, current_user)
    @user = user
    @current_user = current_user
    @email_sharing = email_sharing
    mail to: email_sharing.recipient_email, subject: t('mailers.email_sharing.other_user.subject', fullname: current_user.fullname)
  end

  def public_user(email_sharing, user)
    @user = user
    @email_sharing = email_sharing
    mail to: email_sharing.recipient_email, subject: t('mailers.email_sharing.public_user.subject', fullname: @email_sharing.author_fullname)
  end

  class Preview < MailView

    def user
      name          = Faker::Name.name
      user          = FactoryGirl.create :user, fullname: name, username: name.parameterize, email: "#{name.parameterize}@example.com"
      profile       = FactoryGirl.create :profile, user: user
      email_sharing = FactoryGirl.create :email_sharing, author: user, profile: profile
      email         = EmailSharingMailer.user(email_sharing, user)
      email
    end

    def other_user
      name              = Faker::Name.name
      user              = FactoryGirl.create :user, fullname: name, username: name.parameterize, email: "#{name.parameterize}@example.com"
      current_user_name = Faker::Name.name
      current_user      = FactoryGirl.create :user, fullname: current_user_name, username: current_user_name.parameterize, email: "#{current_user_name.parameterize}@example.com"
      profile           = FactoryGirl.create :profile, user: user
      email_sharing     = FactoryGirl.create :email_sharing, author: current_user, profile: profile
      email             = EmailSharingMailer.other_user(email_sharing, user, current_user)
      email
    end

    def public_user
      name1         = Faker::Name.name
      user1         = FactoryGirl.create :user, fullname: name1, username: name1.parameterize, email: "#{name1.parameterize}@example.com"
      name2         = Faker::Name.name
      user2         = FactoryGirl.create :user, fullname: name2, username: name2.parameterize, email: "#{name2.parameterize}@example.com"
      profile       = FactoryGirl.create :profile, user: user1
      email_sharing = FactoryGirl.create :email_sharing, author: user2, profile: profile
      email         = EmailSharingMailer.public_user(email_sharing, user1)
      email
    end
  end
end
