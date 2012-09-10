class BetaInviteMailer < ActionMailer::Base

  default from: "postman@joblr.co"
  layout 'mailers'

  def send_code(beta_invite)
    @beta_invite = beta_invite
    @subject     = t('mailers.beta_invite.send_code.subject')
    @title       = t('mailers.beta_invite.send_code.title')
    @button      = { text: t('mailers.beta_invite.send_code.button'), url: "http://joblr.co/beta_invites/#{beta_invite.id}/edit" }
    mail to: beta_invite.email, subject: @subject
  end

  def notify_team(beta_invite)
    @beta_invite = beta_invite
    @subject     = t('mailers.beta_invite.notify_team.subject')
    @title       = t('mailers.beta_invite.notify_team.title')
    @button      = { text: t('mailers.beta_invite.notify_team.button'), url: "http://joblr.co/admin" }
    mail to: 'team@joblr.co', subject: @subject
  end
end
