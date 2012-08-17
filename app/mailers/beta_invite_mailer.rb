class BetaInviteMailer < ActionMailer::Base
  default from: "postman@joblr.co"

  def send_invite(invite)
    @invite = invite
    mail to: invite.email, subject: t('beta_invite_mailer.send_invite.subject')
  end
end
