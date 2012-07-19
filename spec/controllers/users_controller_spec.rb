require 'spec_helper'

describe UsersController do

  before :each do
    @user = FactoryGirl.create :user
    sign_in @user
  end

  describe "GET 'edit'" do

    before(:each) { get :edit, id: @user }

    it { response.should be_success }

    it 'should build a profile for the right user' do
      @user.profiles.should_not be_empty
    end
  end
end