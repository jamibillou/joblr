class UserMailer < ActionMailer::Base
  default from: "franck@engaccino.com"

  def share_profile(email)
    @greeting = "Hello, this is my profile, what do you think about it"

    mail to: email, subject: t('user_mailer.share_profile.subject')
  end
end
