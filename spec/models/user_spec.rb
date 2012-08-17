require 'spec_helper'

describe User do

  before :each do
    @user        = FactoryGirl.create :user
    @auth        = FactoryGirl.create :authentification, user: @user, provider:'twitter'
    @profile     = FactoryGirl.create :profile, user: @user
    @beta_invite = FactoryGirl.create :beta_invite, user: @user
    @providers   = %w(linkedin twitter facebook google)
  end

  describe 'authentifications associations' do

    it { @user.should respond_to :authentifications }

    it 'should destroy associated authentifications' do
      @user.destroy
      Authentification.find_by_id(@auth.id).should be_nil
    end
  end

  describe 'profiles associations' do

    it { @user.should respond_to :profiles }

    it 'should destroy associated profiles' do
      @user.destroy
      Profile.find_by_id(@profile.id).should be_nil
    end
  end

  describe 'beta invite association' do

    it { @user.should respond_to :beta_invite }

    it 'should destroy associated beta_invite' do
      @user.destroy
      BetaInvite.find_by_id(@beta_invite.id).should be_nil
    end
  end

  describe 'validations' do

    before :all do
      @email = { :invalid => %w(invalid_email invalid@example invalid@user@example.com inv,alide@), :valid => %w(valid_email@example.com valid@example.co.kr vu@example.us) }
    end

    it { should ensure_length_of(:fullname).is_at_most 100 }
    it { should ensure_length_of(:city).is_at_most 50 }
    it { should ensure_length_of(:country).is_at_most 50 }
    it { should ensure_length_of(:role).is_at_most 100 }
    it { should ensure_length_of(:company).is_at_most 50 }
    it { should ensure_length_of(:username).is_at_most 100 }
    it { should validate_uniqueness_of(:username) }
    it { should validate_presence_of(:username) }
    it { @user.update_attributes(email: @email[:valid][0]) ; should validate_uniqueness_of(:email) }

    lambda do
      @email[:invalid].each do |invalid_email|
        it { should validate_format_of(:email).not_with invalid_email }
      end
    end

    lambda do
      @email[:valid].each do |valid_email|
        it { should validate_format_of(:email).with valid_email }
      end
    end
  end

  describe 'image' do

    it 'should have the right format' # do
    # end

    it 'should uploaded to the right namespace' # do
    # end

    it 'should empty the column when remove_image is checked' # do
    # end

    it 'should delete the uploaded image when remove_image is checked' # do
    # end
  end

  describe 'has_auth? method' do

    it { @user.has_auth?('twitter').should be_true }
    it { @user.has_auth?('facebook').should be_false }

    context ':all given as an argument' do

      it 'should not be true for users having an account from each provider' do
        @providers.each { |p| FactoryGirl.create :authentification, user: @user, provider: p }
        @user.has_auth?(:all).should be_true
      end

      it 'should be false for users not having an account from each provider' do
        @user.has_auth?(:all).should be_false
      end

      it 'should be false for users not having any account' do
        @auth.destroy
        @user.has_auth?(:all).should be_false
      end
    end
  end

  describe 'auth method' do

    it 'facebook' do
      auth = FactoryGirl.create :authentification, user: @user, provider:'facebook'
      @user.auth('facebook').id.should == auth.id
    end

    it 'linkedin' do
      auth = FactoryGirl.create :authentification, user: @user, provider:'linkedin'
      @user.auth('linkedin').id.should == auth.id
    end

    it 'twitter' do
      @user.auth('twitter').id.should == @auth.id
    end

    it 'google_oauth2' do
      auth = FactoryGirl.create :authentification, user: @user, provider:'google_oauth2'
      @user.auth('google_oauth2').id.should == auth.id
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  fullname               :string(255)
#  email                  :string(255)
#  encrypted_password     :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  city                   :string(255)
#  country                :string(255)
#  role                   :string(255)
#  company                :string(255)
#  image                  :string(255)
#  subdomain              :string(255)
#  username               :string(255)
#

