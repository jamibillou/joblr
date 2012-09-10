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

  class Preview < MailView

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
end
