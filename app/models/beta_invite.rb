class BetaInvite < ActiveRecord::Base

  attr_accessible :email, :code, :user_id

  belongs_to :user

  validates :code,  presence: true
  validates :email, presence: true, allow_blank: false
  validates :email, uniqueness: { case_sensitive: true }
  validates :email, format:     { with: Devise.email_regexp }

  before_validation :make_code

  def active?
    !user.nil?
  end

  private

    def make_code
      self.code = Digest::SHA2.hexdigest(Time.now.utc.to_s)
    end
end

# == Schema Information
#
# Table name: beta_invites
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  code       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  email      :string(255)
#

