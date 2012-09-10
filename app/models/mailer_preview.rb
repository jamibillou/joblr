class MailerPreview < MailView

  # EmailSharingMailer

  def user
    name          = Faker::Name.name
    user          = FactoryGirl.create :user, fullname: name, username: name.parameterize, email: "#{name.parameterize}@example.com"
    profile       = FactoryGirl.create :profile, user: user
    email_sharing = FactoryGirl.create :email_sharing, author: user, profile: profile
    email         = EmailSharingMailer.user(email_sharing, user)
    email
  end

  def other_user
    name          = Faker::Name.name
    user          = FactoryGirl.create :user, fullname: name, username: name.parameterize, email: "#{name.parameterize}@example.com"
    profile       = FactoryGirl.create :profile, user: user
    email_sharing = FactoryGirl.create :email_sharing, author: nil, profile: profile
    email         = EmailSharingMailer.other_user(email_sharing, user)
    email
  end

  def public_user
    name1         = Faker::Name.name
    user1         = FactoryGirl.create :user, fullname: name, username: name.parameterize, email: "#{name.parameterize}@example.com"
    name2         = Faker::Name.name
    user2         = FactoryGirl.create :user, fullname: name, username: name.parameterize, email: "#{name.parameterize}@example.com"
    profile       = FactoryGirl.create :profile, user: user1
    email_sharing = FactoryGirl.create :email_sharing, author: user2, profile: profile
    email         = EmailSharingMailer.public_user(email_sharing, user1)
    email
  end


  # BetaInviteMailer

  def send_code
    beta_invite = FactoryGirl.create :beta_invite, email: Faker::Internet.email, user: nil
    email = BetaInviteMailer.send_code beta_invite
    email
  end

  def notify_team
    beta_invite = FactoryGirl.create :beta_invite, email: Faker::Internet.email, user: nil
    email = BetaInviteMailer.notify_team beta_invite
    email
  end
end