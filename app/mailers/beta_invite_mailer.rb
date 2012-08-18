class BetaInviteMailer < ActionMailer::Base
  default from: "postman@joblr.co"

  def send_beta_invite(beta_invite)
    @beta_invite = beta_invite
    mail to: beta_invite.email, subject: "Invitation to joblr alpha"
  end
end
