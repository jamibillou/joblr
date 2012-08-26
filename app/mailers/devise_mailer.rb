class DeviseMailer < ActionMailer::Base
  include Devise::Mailers::Helpers
  default from: "postman@joblr.co"

  def reset_password_instructions(record)
    devise_mail(record, :reset_password_instructions)
  end
end
