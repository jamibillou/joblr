module MailerPreview::BetaInvite

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