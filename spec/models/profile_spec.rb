require 'spec_helper'

describe Profile do
  
  before :each do
    @user = FactoryGirl.create :user
    @profile = FactoryGirl.create :profile, user: @user
    @attr = { education: 'Master of Business Administration',
    	      experience: '5 yrs',
    	      skill_1: 'Financial control',
    	      skill_2: 'Business analysis',
			  skill_3: 'Strategic decision making',
			  skill_1_level: 'Expert',
			  skill_2_level: 'Beginner',
			  skill_3_level: 'Intermediate',
			  quality_1: 'Drive',
			  quality_2: 'Work ethics',
			  quality_3: 'Punctuality' }
  end

  describe 'users associations' do

    it { @profile.should respond_to :user }
    
    it 'should not be valid without a candidate' do
      profile_without_user = Profile.new @attr
      profile_without_user.should_not be_valid
    end
    
    it 'should have the right associated user' do
      @profile.user_id.should == @user.id
      @profile.user.should    == @user
    end
    
    it 'should not destroy associated user' do
      @profile.destroy
      User.find_by_id(@user.id).should_not be_nil
    end
  end
end