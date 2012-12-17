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
#  text               :text
#  status             :string(255)
#  type               :string(255)
#  profile_id         :integer
#  author_id          :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  page               :string(255)
#

class FeedbackEmail < UserEmail
  attr_accessible :page

  validates :page, presence: true

  before_validation :fill_in_recipient

  private

    def fill_in_recipient
      self.recipient_fullname = 'Joblr team'
      self.recipient_email = 'team@joblr.co'
    end
end
