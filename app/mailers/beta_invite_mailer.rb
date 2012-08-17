class BetaInviteMailer < ActionMailer::Base
  default from: "postman@joblr.co"

  def send_invite(invite)
    @invite = invite
    mail to: invite.email, subject: "Invitation to joblr beta"
  end
end
