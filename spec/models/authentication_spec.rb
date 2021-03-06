# == Schema Information
#
# Table name: authentications
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  provider   :string(255)
#  uid        :string(255)
#  uname      :string(255)
#  uemail     :string(255)
#  url        :string(255)
#  utoken     :string(255)
#  usecret    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Authentication do

  before :each do
    @user          = FactoryGirl.create :user
    @twitter_auth  = FactoryGirl.create :authentication, user: @user
    @linkedin_auth = FactoryGirl.create :authentication, user: @user, provider: 'linkedin'
    @facebook_auth = FactoryGirl.create :authentication, user: @user, provider: 'facebook'
    @google_auth   = FactoryGirl.create :authentication, user: @user, provider: 'google'
    @attr          = { provider: 'twitter', uid: 'john_d', uname: 'John Doe' }
  end

  describe 'user association' do

    it { @twitter_auth.should respond_to :user }

    it 'should have the right associated user' do
      @twitter_auth.user_id.should == @user.id
      @twitter_auth.user.should    == @user
    end

    it 'should not destroy associated user' do
      @twitter_auth.destroy
      User.find_by_id(@user.id).should_not be_nil
    end
  end

  describe 'validations' do
    it { should validate_presence_of :user }
    it { should validate_presence_of :provider }
    it { should validate_presence_of :uid }
  end

  describe 'image_url method' do

    context 'for twitter authentications' do

      it 'should have the right format' do
        @twitter_auth.image_url.should =~ /^https:\/\/si0.twimg.com\/\w+/
      end

      it 'should serve a thumb image by default' do
        @twitter_auth.image_url.should =~ /bigger/
      end

      it 'should serve an original image when asked to' do
        @twitter_auth.image_url(:original).should_not =~ /bigger/
      end
    end

    context 'for linkedin authentications' # do
    # end

    context 'for facebook authentications' do

      it 'should have the right format' do
        @facebook_auth.image_url.should =~ /^http:\/\/graph.facebook.com\/\w+\/picture/
      end

      it 'should serve a thumb image by default' do
        @facebook_auth.image_url.should =~ /square/
      end

      it 'should serve an original image when asked to' do
        @facebook_auth.image_url(:original).should =~ /large/
      end
    end

    context 'for google authentications' do
      it 'should have the right format' do
        @google_auth.image_url.should =~ /^https:\/\/profiles.google.com\/s2\/photos\/profile\/\w+$/
      end
    end
  end
end
