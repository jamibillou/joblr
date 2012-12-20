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
#  reply_to           :string(255)
#  subject            :string(255)
#  status             :string(255)
#  type               :string(255)
#  page               :string(255)
#  code               :string(255)
#  text               :text
#  sent               :boolean          default(FALSE)
#  used               :boolean          default(FALSE)
#  profile_id         :integer
#  author_id          :integer
#  recipient_id       :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Email < ActiveRecord::Base
  attr_accessible :author_email, :author_fullname, :recipient_email, :recipient_fullname, :bcc, :cc, :subject, :text

  validates :author_fullname,    length: { maximum: 100 },              unless: :author_id,    presence: true
  validates :author_email,       format: { with: Devise.email_regexp }, unless: :author_id,    presence: true
  validates :recipient_fullname, length: { maximum: 100 },              unless: :recipient_id, presence: true
  validates :recipient_email,    format: { with: Devise.email_regexp }, unless: :recipient_id, presence: true
  validates :cc,                 format: { with: Devise.email_regexp }, allow_blank: true
  validates :bcc,                format: { with: Devise.email_regexp }, allow_blank: true
  validates :reply_to,           format: { with: Devise.email_regexp }, allow_blank: true
  validates :subject,            length: { maximum: 150 },              allow_blank: true
end
