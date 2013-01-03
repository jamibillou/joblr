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

class InviteEmail < ToUserEmail
  attr_accessible :email, :code, :sent, :used

  validates :recipient_email, uniqueness: { case_sensitive: true }, presence: true
  validates :code, presence: true
  validates :sent, inclusion:  { :in => [true, false] }

  before_validation :prefill_fields, :make_code

  def use_invite(user)
    self.recipient = user
    self.used = true
    save
    recipient.update_attributes(email: recipient_email) if recipient.email.nil?
  end

  private

    def prefill_fields
      self.author_fullname    = 'Joblr'
      self.author_email       = 'postman@joblr.co'
      self.recipient_fullname = 'Unknown'
    end

    def make_code
      self.code = Digest::SHA2.hexdigest(Time.now.utc.to_s) unless persisted?
    end
end
