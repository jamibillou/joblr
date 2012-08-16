require 'spec_helper'

describe BetaInvite do

  before :each do
    @user   = FactoryGirl.create :user
    @invite = FactoryGirl.create :beta_invite, user: @user
  end

  describe 'user association' do

    it { @invite.should respond_to :user }

    it 'should have the right associated user' do
      @invite.user_id.should == @user.id
      @invite.user.should == @user
    end

    it 'should not destroy the associated user' do
      @invite.destroy
      User.find_by_id(@user.id).should_not be_nil
    end
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

