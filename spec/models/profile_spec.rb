require 'spec_helper'

describe Profile do

  before :each do
    @user          = FactoryGirl.create :user, username: FactoryGirl.generate(:username), fullname: FactoryGirl.generate(:fullname), email: FactoryGirl.generate(:email)
    @profile       = FactoryGirl.create :profile, user: @user
    @email_sharing = FactoryGirl.create :email_sharing, author: @user, profile: @profile
    @attr = { headline: 'fulltime',
              experience: '5 yrs',
              last_job: 'Financial director',
              past_companies: 'Cathay Pacific, Bank of China',
              education: 'Master of Business Administration',
              skill_1: 'Financial control',
              skill_2: 'Business analysis',
              skill_3: 'Strategic decision making',
              skill_1_level: 'Expert',
              skill_2_level: 'Beginner',
              skill_3_level: 'Intermediate',
              quality_1: 'Drive',
              quality_2: 'Work ethics',
              quality_3: 'Punctuality',
              text: 'Do or do not, there is no try.' }
  end

  it 'should create a profile given valid attributes' do
    @user.profiles.build(@attr).should be_valid
  end

  describe 'user association' do

    it { @profile.should respond_to :user }

    it 'should have the right associated user' do
      @profile.user_id.should == @user.id
      @profile.user.should    == @user
    end

    it 'should not destroy associated user' do
      @profile.destroy
      User.find_by_id(@user.id).should_not be_nil
    end
  end

  describe 'email sharings associations' do

    it { @profile.should respond_to :email_sharings }

    it 'should destroy associated sharings' do
      @profile.destroy
      EmailSharing.find_by_id(@email_sharing.id).should be_nil
    end
  end

  describe 'validations' do

    before :all do
      @headline = { valid: %w(fulltime partime internship freelance), invalid: [ 'Looking for work!', 'Unemployed', 'Broke' ] }
      @level    = { valid: %w(Beginner Intermediate Advanced Expert), invalid: %w(crap good okish) }
      @url      = { valid: %w(http://www.engaccino.com https://engaccino.com https://dom.engaccino.com http://franck.engaccino.com http://www.engaccino.co.uk https://dom.engaccino.com.hk http://engaccino.me http://www.engaccino.ly http://fr.engaccino/users/1/edit),
                    invalid: %w(invalid_url engaccino.com pouetpouetpouet http:www.engaccino.com http//engaccino.com http/ccino.co htp://ccino.me http:/www.engaccino.com) }
    end

    it { should validate_presence_of :user }
    it { should validate_presence_of :headline }
    it { should validate_presence_of :experience }
    it { should validate_presence_of :education }
    it { should validate_presence_of :text }
    it { should ensure_length_of(:headline).is_at_most 100 }
    it { should ensure_length_of(:experience).is_at_most 100 }
    it { should ensure_length_of(:education).is_at_most 100 }
    it { should ensure_length_of(:text).is_at_most 140 }
    it { should ensure_length_of(:last_job).is_at_most 100 }
    it { should ensure_length_of(:past_companies).is_at_most 100 }
    it { should ensure_length_of(:skill_1).is_at_most 50 }
    it { should ensure_length_of(:skill_2).is_at_most 50 }
    it { should ensure_length_of(:skill_3).is_at_most 50 }
    it { should ensure_length_of(:quality_1).is_at_most 50 }
    it { should ensure_length_of(:quality_2).is_at_most 50 }
    it { should ensure_length_of(:quality_3).is_at_most 50 }

    lambda { @headline[:invalid].each {|invalid_headline| it { should validate_format_of(:headline).not_with(invalid_headline).with_message(I18n.t('activerecord.errors.messages.headline_format')) }}}
    lambda { @headline[:valid].each   {|valid_headline|   it { should validate_format_of(:headline).with valid_headline }}}

    lambda { @url[:invalid].each {|invalid_url| it { should validate_format_of(:url).not_with(invalid_url).with_message(I18n.t('activerecord.errors.messages.url_format')) }}}
    lambda { @url[:valid].each   {|valid_url|   it { should validate_format_of(:url).with valid_url }}}

    lambda { @level[:valid].each {|invalid_level| %w(skill_1_level skill_2_level skill_3_level).each {|skill_level| it { should validate_format_of(skill_level).not_with(invalid_level).with_message(I18n.t('activerecord.errors.messages.level_format')) }}}}
    lambda { @level[:valid].each {|valid_level|   %w(skill_1_level skill_2_level skill_3_level).each {|skill_level| it { should validate_format_of(skill_level).with valid_level }}}}
  end

  describe 'file' do

    it 'should have the right format' # do
    # end

    it 'should uploaded to the right namespace' # do
    # end

    it 'should empty the column when remove_file is checked' # do
    # end

    it 'should delete the uploaded file when remove_file is checked' # do
    # end
  end
end

# == Schema Information
#
# Table name: profiles
#
#  id             :integer         not null, primary key
#  user_id        :integer
#  headline       :string(255)
#  experience     :string(255)
#  last_job       :string(255)
#  past_companies :string(255)
#  education      :string(255)
#  skill_1        :string(255)
#  skill_1_level  :string(255)
#  skill_2        :string(255)
#  skill_2_level  :string(255)
#  skill_3        :string(255)
#  skill_3_level  :string(255)
#  quality_1      :string(255)
#  quality_2      :string(255)
#  quality_3      :string(255)
#  file           :string(255)
#  url            :string(255)
#  text           :string(255)
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

