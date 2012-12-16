class SharingEmailMailer < ActionMailer::Base

  default from: "postman@joblr.co"
  layout 'mailers', only: [:decline, :decline_through_other]

  def user(sharing_email, user)
  	@user = user
    @sharing_email = sharing_email
    mail to: sharing_email.recipient_email, subject: t('mailers.sharing_email.user.subject', fullname: user.fullname), reply_to: @user.email
  end

  def other_user(sharing_email, user, current_user)
    @user = user
    @current_user = current_user
    @sharing_email = sharing_email
    mail to: sharing_email.recipient_email, subject: t('mailers.sharing_email.other_user.subject', fullname: current_user.fullname), reply_to: @user.email
  end

  def public_user(sharing_email, user)
    @user = user
    @sharing_email = sharing_email
    mail to: sharing_email.recipient_email, subject: t('mailers.sharing_email.public_user.subject', fullname: sharing_email.author_fullname), reply_to: @user.email
  end

  def decline(sharing_email)
    @sharing_email = sharing_email
    @subject = t('mailers.sharing_email.decline.subject', fullname: sharing_email.recipient_fullname)
    @title   = t('mailers.sharing_email.decline.title',   fullname: sharing_email.recipient_fullname)
    mail to: sharing_email.profile.user.email, subject: @subject
  end

  def decline_through_other(sharing_email)
    @sharing_email = sharing_email
    @author_fullname = sharing_email.author.nil? ? sharing_email.author_fullname : sharing_email.author.fullname
    @subject = t('mailers.sharing_email.decline_through_other.subject', fullname: sharing_email.recipient_fullname)
    @title   = t('mailers.sharing_email.decline_through_other.title',   fullname: sharing_email.recipient_fullname)
    mail to: sharing_email.profile.user.email, subject: @subject
  end

  class Preview < MailView

    def user
      name          = Faker::Name.name
      user          = FactoryGirl.create :user, fullname: name, username: name.parameterize, email: "#{name.parameterize}@example.com"
      profile       = FactoryGirl.create :profile, user: user
      sharing_email = FactoryGirl.create :sharing_email, author: user, profile: profile
      email         = SharingEmailMailer.user(sharing_email, user)
      email
    end

    def other_user
      name              = Faker::Name.name
      user              = FactoryGirl.create :user, fullname: name, username: name.parameterize, email: "#{name.parameterize}@example.com"
      current_user_name = Faker::Name.name
      current_user      = FactoryGirl.create :user, fullname: current_user_name, username: current_user_name.parameterize, email: "#{current_user_name.parameterize}@example.com"
      profile           = FactoryGirl.create :profile, user: user
      sharing_email     = FactoryGirl.create :sharing_email, author: current_user, profile: profile
      email             = SharingEmailMailer.other_user(sharing_email, user, current_user)
      email
    end

    def public_user
      name1         = Faker::Name.name
      user1         = FactoryGirl.create :user, fullname: name1, username: name1.parameterize, email: "#{name1.parameterize}@example.com"
      name2         = Faker::Name.name
      user2         = FactoryGirl.create :user, fullname: name2, username: name2.parameterize, email: "#{name2.parameterize}@example.com"
      profile       = FactoryGirl.create :profile, user: user1
      sharing_email = FactoryGirl.create :sharing_email, author: user2, profile: profile
      email         = SharingEmailMailer.public_user(sharing_email, user1)
      email
    end

    def decline
      name          = Faker::Name.name
      user          = FactoryGirl.create :user, fullname: name, username: name.parameterize, email: "#{name.parameterize}@example.com"
      profile       = FactoryGirl.create :profile, user: user
      sharing_email = FactoryGirl.create :sharing_email, author: user, profile: profile
      email         = SharingEmailMailer.decline(sharing_email)
      email
    end

    def decline_through_other
      name          = Faker::Name.name
      user          = FactoryGirl.create :user, fullname: name, username: name.parameterize, email: "#{name.parameterize}@example.com"
      name2         = Faker::Name.name
      user2         = FactoryGirl.create :user, fullname: name2, username: name2.parameterize, email: "#{name2.parameterize}@example.com"
      profile       = FactoryGirl.create :profile, user: user
      sharing_email = FactoryGirl.create :sharing_email, author: user2, profile: profile
      email         = SharingEmailMailer.decline_through_other(sharing_email)
      email
    end
  end
end
