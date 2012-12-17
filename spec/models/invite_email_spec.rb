# == Schema Information
#
# Table name: emails
#
#  id                 :integer          not null, primary key
#  author_fullname    :string(255)
#  author_email       :string(255)
#  recipient_fullname :string(255)
#  recipient_email    :string(255)
#  cc                 :string(255)
#  bcc                :string(255)
#  subject            :string(255)
#  text               :text
#  status             :string(255)
#  type               :string(255)
#  profile_id         :integer
#  author_id          :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  page               :string(255)
#  code               :string(255)
#  user_id            :integer
#  sent               :boolean          default(FALSE)
#

require 'spec_helper'

describe InviteEmail do

  before :each do
    @user         = FactoryGirl.create :user
    @invite_email = FactoryGirl.create :invite_email, user: @user
    @attr         = {recipient_email: FactoryGirl.generate(:email)}
  end

  it 'should inherit from the Email model' do
    InviteEmail.should < Email
  end

  describe 'user association' do

    it { @invite_email.should respond_to :user }

    it 'should have the right associated user' do
      @invite_email.user_id.should == @user.id
      @invite_email.user.should == @user
    end

    it 'should not destroy the associated user' do
      @invite_email.destroy
      User.find_by_id(@user.id).should_not be_nil
    end
  end

  describe 'validations' do
    it { should allow_value('').for(:recipient_fullname) }
    it { should validate_uniqueness_of(:recipient_email) }
    it { should ensure_inclusion_of(:sent).in_array [true, false] }
  end

  it 'should fill in Joblr team as author before validation' do
    invite_email = InviteEmail.new @attr
    invite_email.should be_valid
    invite_email.author_fullname.should == 'Joblr team'
    invite_email.author_email.should == 'team@joblr.co'
    invite_email.recipient_fullname.should == 'Unknown'
  end
end
