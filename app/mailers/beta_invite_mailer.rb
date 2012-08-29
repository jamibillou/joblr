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
end
