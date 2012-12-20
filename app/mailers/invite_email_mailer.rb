class InviteEmailMailer < ActionMailer::Base

  default from: 'postman@joblr.co'
  layout 'emails'

  def notify_team(invite_email)
    @invite_email = invite_email
    @subject     = t('mailers.invite_email.notify_team.subject')
    @title       = t('mailers.invite_email.notify_team.title')
    @button      = { text: t('mailers.invite_email.notify_team.button'), url: "http://joblr.co/users/sign_in" }
    mail to: 'team@joblr.co', subject: @subject
  end

  def send_code(invite_email)
    @invite_email = invite_email
    @subject     = t('mailers.invite_email.send_code.subject')
    @title       = t('mailers.invite_email.send_code.title')
    @button      = { text: t('mailers.invite_email.send_code.button'), url: "http://joblr.co/invite_emails/#{invite_email.id}/edit?code=#{@invite_email.code}" }
    mail to: invite_email.recipient_email, subject: @subject
  end

  class Preview < MailView

    def notify_team
      invite_email = FactoryGirl.create :invite_email, recipient_email: Faker::Internet.email, recipient: nil
      email = InviteEmailMailer.notify_team invite_email
      email
    end

    def send_code
      invite_email = FactoryGirl.create :invite_email, recipient_email: Faker::Internet.email, recipient: nil
      email = InviteEmailMailer.send_code invite_email
      email
    end
  end
end
