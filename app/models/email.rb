# == Schema Information
#
# Table name: emails
#
#  id                 :integer          not null, primary key
#  author_fullname    :string(255)
#  author_email       :string(255)
#  recipient_fullname :string(255)
#  recipient_email    :string(255)
#  cc                 :string(255)
#  bcc                :string(255)
#  subject            :string(255)
#  text               :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Email < ActiveRecord::Base
  attr_accessible :author_email, :author_fullname, :bcc, :cc, :recipient_email, :recipient_fullname, :subject, :text

  validates :author_fullname,    length: { maximum: 100 },              presence: true
  validates :author_email,       format: { with: Devise.email_regexp }, presence: true
  validates :recipient_fullname, length: { maximum: 100 },              presence: true
  validates :recipient_email,    format: { with: Devise.email_regexp }, presence: true
  validates :cc,                 format: { with: Devise.email_regexp }, allow_blank: true
  validates :bcc,                format: { with: Devise.email_regexp }, allow_blank: true
  validates :subject,            length: { maximum: 150 },              presence: true
  validates :text,                                                      presence: true
end
