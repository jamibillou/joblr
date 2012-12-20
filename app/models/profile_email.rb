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

class ProfileEmail < FromUserEmail
  attr_accessible :profile_id, :profile, :status

  belongs_to :profile

  validates :text,   length: { maximum: 140 }, presence: true
  validates :status, inclusion: { :in => ['accepted', 'declined'] }, allow_nil: true
end
