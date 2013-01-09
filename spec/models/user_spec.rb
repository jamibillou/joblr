# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  fullname               :string(255)
#  email                  :string(255)
#  encrypted_password     :string(255)
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  username               :string(255)
#  image                  :string(255)
#  city                   :string(255)
#  country                :string(255)
#  subdomain              :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  admin                  :boolean          default(FALSE)
#  social                 :boolean          default(FALSE)
#

require 'spec_helper'

describe User do

  before :each do
    @user            = FactoryGirl.create :user, username: FactoryGirl.generate(:username), fullname: FactoryGirl.generate(:fullname), email: FactoryGirl.generate(:email)
    @auth            = FactoryGirl.create :authentication, user: @user, provider:'twitter'
    @profile         = FactoryGirl.create :profile, user: @user
    @providers       = %w(linkedin twitter facebook google)
    @from_user_email = FactoryGirl.create :from_user_email, author: @user
    @profile_email   = FactoryGirl.create :profile_email,   author: @user
    @feedback_email  = FactoryGirl.create :feedback_email,  author: @user
    @to_user_email   = FactoryGirl.create :to_user_email, recipient: @user
    @invite_email    = FactoryGirl.create :invite_email,  recipient: @user
  end

  describe 'authentications associations' do

    it { @user.should respond_to :authentications }

    it 'should destroy associated authentications' do
      @user.destroy
      Authentication.find_by_id(@auth.id).should be_nil
    end
  end

  describe 'profiles associations' do

    it { @user.should respond_to :profiles }

    it 'should destroy associated profiles' do
      @user.destroy
      Profile.find_by_id(@profile.id).should be_nil
    end
  end

  describe 'from_user_emails associations' do

    it { @user.should respond_to :authored_emails }

    it 'should destroy associated from_user_emails' do
      @user.destroy
      FromUserEmail.find_by_id(@from_user_email.id).should be_nil
    end
  end

  describe 'profile_emails associations' do

    it 'should destroy associated profile_emails' do
      @user.destroy
      ProfileEmail.find_by_id(@profile_email.id).should be_nil
    end
  end

  describe 'feedback_emails associations' do

    it 'should destroy associated feedback_emails' do
      @user.destroy
      FeedbackEmail.find_by_id(@feedback_email.id).should be_nil
    end
  end

  describe 'to_user_emails associations' do

    it { @user.should respond_to :received_emails }

    it 'should destroy associated to_user_emails' do
      @user.destroy
      ToUserEmail.find_by_id(@to_user_email.id).should be_nil
    end
  end

  describe 'invite_email association' do

    it { @user.should respond_to :invite_email }

    it 'should destroy associated invite_email' do
      @user.destroy
      InviteEmail.find_by_id(@invite_email.id).should be_nil
    end
  end

  describe 'validations' do

    before :all do
      @email =     { invalid: %w(invalid_email invalid@example invalid@user@example.com inv,alide@), valid: %w(valid_email@example.com valid@example.co.kr vu@example.us) }
      @subdomain = { invalid: ['dom choa', 'dom__choa', 'dom.choa', 'dom--choa', 'dom@choa', 'dom%choa', 'dom_', '_choa', 'dom-', '-choa'], valid: %(dominic_m dominic-m dominicm dominic12345 12345dominicm) }
    end

    it { should ensure_length_of(:fullname).is_at_most 100 }
    it { should validate_presence_of(:fullname) }
    it { should ensure_length_of(:city).is_at_most 50 }
    it { should ensure_length_of(:country).is_at_most 50 }
    it { should ensure_length_of(:username).is_at_most 63 }
    it { should validate_uniqueness_of(:username) }
    it { should validate_presence_of(:username) }
    it { should validate_format_of(:username).not_with(@subdomain[:invalid][rand(@subdomain[:invalid].size)]).with_message(I18n.t('activerecord.errors.messages.subdomain_format')) }
    it { should validate_format_of(:username).with @subdomain[:valid][rand(@subdomain[:valid].size)] }
    it { FactoryGirl.build(:user, username: FactoryGirl.generate(:username), fullname: FactoryGirl.generate(:fullname), email: @user.email).should_not be_valid }
    it { should ensure_length_of(:subdomain).is_at_most 63 }
    it { should validate_uniqueness_of(:subdomain) }
    it { should validate_format_of(:subdomain).not_with(@subdomain[:invalid][rand(@subdomain[:invalid].size)]).with_message(I18n.t('activerecord.errors.messages.subdomain_format')) }
    it { should validate_format_of(:subdomain).with @subdomain[:valid][rand(@subdomain[:valid].size)] }
    it { should ensure_inclusion_of(:admin).in_array [true, false] }
    it { should ensure_inclusion_of(:social).in_array [true, false] }
    it { should validate_format_of(:email).not_with(@email[:invalid][rand(@email[:invalid].size)]).with_message(I18n.t('activerecord.errors.messages.invalid')) }
    it { should validate_format_of(:email).with @email[:valid][rand(@email[:valid].size)] }
  end

  describe 'update_subdomain filter' do

    it 'should update the subdmain after creating a user' do
      @user.subdomain.should == @user.username
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

  describe 'profile method' do

    context 'for users without a profile' do
      it 'should be nil' do
        @profile.destroy
        @user.profile.should be_nil
      end
    end

    context 'for users with one ore more profiles' do
      it 'should be the first profile' do
        @user.profile.should == @profile
      end
    end
  end

  describe 'has_auth? method' do
    it { @user.has_auth?('twitter').should be_true }
    it { @user.has_auth?('facebook').should be_false }
  end

  describe 'auth method' do

    it 'facebook' do
      auth = FactoryGirl.create :authentication, user: @user, provider:'facebook'
      @user.auth('facebook').id.should == auth.id
    end

    it 'linkedin' do
      auth = FactoryGirl.create :authentication, user: @user, provider:'linkedin'
      @user.auth('linkedin').id.should == auth.id
    end

    it 'twitter' do
      @user.auth('twitter').id.should == @auth.id
    end

    it 'google' do
      auth = FactoryGirl.create :authentication, user: @user, provider:'google'
      @user.auth('google').id.should == auth.id
    end
  end

  describe 'has_authored_profile_emails? method' do

    context 'for users without profile emails' do
      it 'should be false' do
        @profile_email.destroy
        @user.has_authored_profile_emails?.should be_false
      end
    end

    context 'for users with profile emails' do
      it 'should be true' do
        @user.has_authored_profile_emails?.should be_true
      end
    end
  end

  describe 'authored_profile_emails_by_date method' # do
  # end

  describe 'initials method' do
    it "should be the initials of the user's full name" do
      @user.initials.should == @user.fullname.parameterize.split('-').map{|name| name.chars.first}.join
    end
  end
end
