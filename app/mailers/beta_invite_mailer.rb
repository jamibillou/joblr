class BetaInviteMailer < ActionMailer::Base
  default from: "postman@joblr.co"

  def send_beta_invite(beta_invite)
    @beta_invite = beta_invite
    mail to: beta_invite.email, subject: t('mailers.beta_invite.subject')
  end
end
