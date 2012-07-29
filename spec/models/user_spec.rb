require 'spec_helper'

describe User do

  before :each do
    @user      = FactoryGirl.create :user
    @auth      = FactoryGirl.create :authentification, user: @user, provider:'twitter'
    @profile   = FactoryGirl.create :profile, user: @user
    @providers = %w(linkedin twitter facebook google)
  end

  describe 'authetifications associations' do

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

  describe 'validations' do
    it { should ensure_length_of(:fullname).is_at_most 100 }
    it { should ensure_length_of(:city).is_at_most 50 }
    it { should ensure_length_of(:country).is_at_most 50 }
    it { should ensure_length_of(:role).is_at_most 100 }
    it { should ensure_length_of(:company).is_at_most 50 }
  end

  describe 'has_provider? method' do

    it { @user.has_provider?('twitter').should be_true }
    it { @user.has_provider?('facebook').should be_false }

    context ':all given as an argument' do

      it 'should be true for users having an account from each provider' do
        @providers.each { |p| FactoryGirl.create :authentification, user: @user, provider: p }
        @user.has_provider?(:all).should be_true
      end

      it 'should be false for users not having an account from each provider' do
        @user.has_provider?(:all).should be_false
      end

      it 'should be false for users not having any account' do
        @auth.destroy
        @user.has_provider?(:all).should be_false
      end
    end
  end

  describe 'auths_w_pic method' do

    it 'should be empty for users not having any authentification with pic' do
      @user.auths_w_pic.should be_empty
    end

    it 'should not be empty for users having authentifications with pic' do
      @auth_w_pic = FactoryGirl.create :authentification, user: @user, provider:'facebook', upic:'fb.png'
      @user.auths_w_pic.should_not be_empty
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

