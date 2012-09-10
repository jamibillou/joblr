class BetaInviteMailer < ActionMailer::Base
  default from: "postman@joblr.co"

  def send_code(beta_invite)
    @beta_invite = beta_invite
    mail to: beta_invite.email, subject: t('mailers.beta_invite.send_code.subject')
  end

  def notify_team(beta_invite)
    @beta_invite = beta_invite
    mail to: 'team@joblr.co', subject: t('mailers.beta_invite.notify_team.subject')
  end

  class Preview < MailView

    def send_code
      beta_invite = FactoryGirl.create :beta_invite, email: FactoryGirl.generate(:email), user: nil
      email = BetaInviteMailer.send_code beta_invite
      email
    end

    def notify_team
      beta_invite = FactoryGirl.create :beta_invite, email: FactoryGirl.generate(:email), user: nil
      email = BetaInviteMailer.notify_team beta_invite
      email
    end
  end
end
