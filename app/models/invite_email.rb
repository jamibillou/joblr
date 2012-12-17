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
#  code               :string(255)
#  user_id            :integer
#  sent               :boolean          default(FALSE)
#

class InviteEmail < Email

  attr_accessible :email, :code, :sent, :user_id

  belongs_to :user

  validates :recipient_email, uniqueness: { case_sensitive: true }
  validates :sent,  inclusion:  { :in => [true, false] }

  before_validation :prefill_fields, :make_code

  def invite_used?
    !user.nil?
  end

  private

    def prefill_fields
      self.author_fullname = 'Joblr team'
      self.author_email = 'team@joblr.co'
      self.recipient_fullname = 'Unknown'
    end

    def make_code
      self.code = Digest::SHA2.hexdigest(Time.now.utc.to_s) unless persisted?
    end
end
