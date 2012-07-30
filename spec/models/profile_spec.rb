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
              quality_3: 'Punctuality',
              text: 'Do or do not, there is no try.' }
  end

  it 'should create a profile given valid attributes' do
    @user.profiles.build(@attr).should be_valid
  end

  describe 'users associations' do

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

  describe 'validations' do

    before :all do
      @level = { valid: %w(Beginner Intermediate Advanced Expert), invalid: %w(crap good okish) }
      @url   = { valid: %w(http://www.engaccino.com https://engaccino.com https://dom.engaccino.com http://franck.engaccino.com http://www.engaccino.co.uk https://dom.engaccino.com.hk http://engaccino.me http://www.engaccino.ly http://fr.engaccino/users/1/edit),
                 invalid: %w(invalid_url engaccino.com pouetpouetpouet http:www.engaccino.com http//engaccino.com http/ccino.co htp://ccino.me http:/www.engaccino.com) }
    end

    it { should validate_presence_of :user }
    it { should ensure_length_of(:experience).is_at_most 100 }
    it { should ensure_length_of(:education).is_at_most 100 }
    it { should validate_presence_of :experience }
    it { should validate_presence_of :education }
    it { should ensure_length_of(:skill_1).is_at_most 50 }
    it { should ensure_length_of(:skill_2).is_at_most 50 }
    it { should ensure_length_of(:skill_3).is_at_most 50 }
    it { should validate_format_of(:skill_1_level).not_with(@level[:invalid]).with_message(I18n.t('activerecord.errors.messages.level_format')) }
    it { should validate_format_of(:skill_1_level).with @level[:valid] }
    it { should validate_format_of(:skill_2_level).not_with(@level[:invalid]).with_message(I18n.t('activerecord.errors.messages.level_format')) }
    it { should validate_format_of(:skill_2_level).with @level[:valid] }
    it { should validate_format_of(:skill_3_level).not_with(@level[:invalid]).with_message(I18n.t('activerecord.errors.messages.level_format')) }
    it { should validate_format_of(:skill_3_level).with @level[:valid] }
    it { should ensure_length_of(:quality_1).is_at_most 50 }
    it { should ensure_length_of(:quality_2).is_at_most 50 }
    it { should ensure_length_of(:quality_3).is_at_most 50 }
    it { should ensure_length_of(:text).is_at_most 140 }
    it { should validate_presence_of :text }
    it { should validate_format_of(:url).not_with(@url[:invalid]).with_message(I18n.t('activerecord.errors.messages.url_format')) }
    it { should validate_format_of(:url).with @url[:valid] }
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

## == Schema Information
#
# Table name: profiles
#
#  id            :integer         not null, primary key
#  user_id       :integer
#  experience    :string(255)
#  education     :string(255)
#  skill_1       :string(255)
#  skill_1_level :string(255)
#  skill_2       :string(255)
#  skill_2_level :string(255)
#  skill_3       :string(255)
#  skill_3_level :string(255)
#  quality_1     :string(255)
#  quality_2     :string(255)
#  quality_3     :string(255)
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#  text          :string(255)
#

# == Schema Information
#
# Table name: profiles
#
#  id            :integer         not null, primary key
#  user_id       :integer
#  experience    :string(255)
#  education     :string(255)
#  skill_1       :string(255)
#  skill_1_level :string(255)
#  skill_2       :string(255)
#  skill_2_level :string(255)
#  skill_3       :string(255)
#  skill_3_level :string(255)
#  quality_1     :string(255)
#  quality_2     :string(255)
#  quality_3     :string(255)
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#  text          :string(255)
#  url           :string(255)
#  file          :string(255)
#

# == Schema Information
#
# Table name: profiles
#
#  id            :integer         not null, primary key
#  user_id       :integer
#  experience    :string(255)
#  education     :string(255)
#  skill_1       :string(255)
#  skill_1_level :string(255)
#  skill_2       :string(255)
#  skill_2_level :string(255)
#  skill_3       :string(255)
#  skill_3_level :string(255)
#  quality_1     :string(255)
#  quality_2     :string(255)
#  quality_3     :string(255)
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#  text          :string(255)
#  url           :string(255)
#  file          :string(255)
#

