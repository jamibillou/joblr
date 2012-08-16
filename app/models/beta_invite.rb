class BetaInvite < ActiveRecord::Base

  attr_accessible :code, :user_id

  belongs_to :user

  validates :code, presence: true

  before_validation :build_code

  private

    def build_code
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
#

