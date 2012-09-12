class DeviseMailer < ActionMailer::Base

  include Devise::Mailers::Helpers
  default from: 'postman@joblr.co'
  layout 'mailers'

  def reset_password_instructions(record)
    @subject = t('mailers.devise.reset_password_instructions.subject')
    @title   = t('mailers.devise.reset_password_instructions.title')
    devise_mail(record, :reset_password_instructions)
  end
end
