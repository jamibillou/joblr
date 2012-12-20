class ProfileEmailMailer < ActionMailer::Base

  default from: 'postman@joblr.co'
  default reply_to: 'team@joblr.co'
  layout 'emails', only: [:decline, :decline_through_other]

  def user(profile_email, user)
  	@user = user
    @profile_email = profile_email
    mail to: profile_email.recipient_email, subject: t('mailers.profile_email.user.subject', fullname: user.fullname), reply_to: @user.email
  end

  def other_user(profile_email, user, current_user)
    @user = user
    @current_user = current_user
    @profile_email = profile_email
    mail to: profile_email.recipient_email, subject: t('mailers.profile_email.other_user.subject', author_fullname: current_user.fullname, user_fullname: profile_email.profile.user.fullname), reply_to: @user.email
  end

  def public_user(profile_email, user)
    @user = user
    @profile_email = profile_email
    mail to: profile_email.recipient_email, subject: t('mailers.profile_email.public_user.subject', author_fullname: profile_email.author_fullname, user_fullname: profile_email.profile.user.fullname), reply_to: @user.email
  end

  def decline(profile_email)
    @profile_email = profile_email
    @subject = t('mailers.profile_email.decline.subject', fullname: profile_email.recipient_fullname)
    @title   = t('mailers.profile_email.decline.title',   fullname: profile_email.recipient_fullname)
    mail to: profile_email.profile.user.email, subject: @subject
  end

  def decline_through_other(profile_email)
    @profile_email = profile_email
    @author_fullname = profile_email.author.nil? ? profile_email.author_fullname : profile_email.author.fullname
    @subject = t('mailers.profile_email.decline_through_other.subject', author_fullname: @author_fullname, recipient_fullname: profile_email.recipient_fullname)
    @title   = t('mailers.profile_email.decline_through_other.title', recipient_fullname: profile_email.recipient_fullname)
    mail to: profile_email.profile.user.email, subject: @subject
  end

  class Preview < MailView

    def user
      name          = Faker::Name.name
      user          = FactoryGirl.create :user, fullname: name, username: name.parameterize, email: "#{name.parameterize}@example.com"
      profile       = FactoryGirl.create :profile, user: user
      profile_email = FactoryGirl.create :profile_email, author: user, profile: profile
      email         = ProfileEmailMailer.user(profile_email, user)
      email
    end

    def other_user
      name              = Faker::Name.name
      user              = FactoryGirl.create :user, fullname: name, username: name.parameterize, email: "#{name.parameterize}@example.com"
      current_user_name = Faker::Name.name
      current_user      = FactoryGirl.create :user, fullname: current_user_name, username: current_user_name.parameterize, email: "#{current_user_name.parameterize}@example.com"
      profile           = FactoryGirl.create :profile, user: user
      profile_email     = FactoryGirl.create :profile_email, author: current_user, profile: profile
      email             = ProfileEmailMailer.other_user(profile_email, user, current_user)
      email
    end

    def public_user
      name1         = Faker::Name.name
      user1         = FactoryGirl.create :user, fullname: name1, username: name1.parameterize, email: "#{name1.parameterize}@example.com"
      name2         = Faker::Name.name
      user2         = FactoryGirl.create :user, fullname: name2, username: name2.parameterize, email: "#{name2.parameterize}@example.com"
      profile       = FactoryGirl.create :profile, user: user1
      profile_email = FactoryGirl.create :profile_email, author: user2, profile: profile
      email         = ProfileEmailMailer.public_user(profile_email, user1)
      email
    end

    def decline
      name          = Faker::Name.name
      user          = FactoryGirl.create :user, fullname: name, username: name.parameterize, email: "#{name.parameterize}@example.com"
      profile       = FactoryGirl.create :profile, user: user
      profile_email = FactoryGirl.create :profile_email, author: user, profile: profile
      email         = ProfileEmailMailer.decline(profile_email)
      email
    end

    def decline_through_other
      name          = Faker::Name.name
      user          = FactoryGirl.create :user, fullname: name, username: name.parameterize, email: "#{name.parameterize}@example.com"
      name2         = Faker::Name.name
      user2         = FactoryGirl.create :user, fullname: name2, username: name2.parameterize, email: "#{name2.parameterize}@example.com"
      profile       = FactoryGirl.create :profile, user: user
      profile_email = FactoryGirl.create :profile_email, author: user2, profile: profile
      email         = ProfileEmailMailer.decline_through_other(profile_email)
      email
    end
  end
end
