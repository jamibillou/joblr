require 'spec_helper'

describe User do
  
  before :each do
    @user = FactoryGirl.create :user
    @profile = FactoryGirl.create :profile, user: @user
  end

  describe 'profiles associations' do

    it { @user.should respond_to :profiles }
    
    it 'should destroy associated profiles' do
      @user.destroy
      Profile.find_by_id(@profile.id).should be_nil
    end
  end
end