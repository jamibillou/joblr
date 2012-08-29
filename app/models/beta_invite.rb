class BetaInvite < ActiveRecord::Base

  attr_accessible :email, :code, :sent, :user_id

  belongs_to :user

  validates :email, uniqueness: { case_sensitive: true }, allow_blank: false, presence: true
  validates :email, format:     { with: Devise.email_regexp }
  validates :sent,  inclusion:  { :in => [true, false] }
  before_validation :make_code

  def used?
    !user.nil?
  end

  def sent?
    sent == true
  end

  private

    def make_code
      self.code = Digest::SHA2.hexdigest(Time.now.utc.to_s) unless persisted?
    end
end

# == Schema Information
#
# Table name: beta_invites
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  code       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  sent       :boolean         default(FALSE)
#

