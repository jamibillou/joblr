class MailerPreview < MailView

  include MailerPreview::EmailSharing
  include MailerPreview::BetaInvite
end