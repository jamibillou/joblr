# == Schema Information
#
# Table name: emails
#
#  id                 :integer          not null, primary key
#  recipient_id       :integer
#  code               :string(255)
#  recipient_email    :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  sent               :boolean          default(FALSE)
#  author_fullname    :string(255)
#  author_email       :string(255)
#  recipient_fullname :string(255)
#  cc                 :string(255)
#  bcc                :string(255)
#  reply_to           :string(255)
#  subject            :string(255)
#  status             :string(255)
#  type               :string(255)
#  page               :string(255)
#  text               :string(255)
#  used               :boolean          default(FALSE)
#  profile_id         :integer
#  author_id          :integer
#

class FeedbackEmail < FromUserEmail
  attr_accessible :page

  validates :text, presence: true
  validates :page, presence: true

  before_validation :prefill_fields

  private

    def prefill_fields
      self.recipient_fullname = 'Joblr'
      self.recipient_email = 'team@joblr.co'
    end
end
