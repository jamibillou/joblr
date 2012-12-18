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
#  status             :string(255)
#  type               :string(255)
#  page               :string(255)
#  code               :string(255)
#  text               :text
#  sent               :boolean          default(FALSE)
#  used               :boolean          default(FALSE)
#  profile_id         :integer
#  author_id          :integer
#  recipient_id       :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'spec_helper'

describe InviteEmail do

  before :each do
    @recipient    = FactoryGirl.create :recipient
    @invite_email = FactoryGirl.create :invite_email, recipient: @recipient
    @attr         = {recipient_email: FactoryGirl.generate(:email)}
  end

  it 'should inherit from the ToUserEmail model' do
    InviteEmail.should < ToUserEmail
  end

  describe 'recipient association' do

    it { @invite_email.should respond_to :recipient }

    it 'should have the right associated recipient' do
      @invite_email.recipient_id.should == @recipient.id
      @invite_email.recipient.should == @recipient
    end

    it 'should not destroy the associated recipient' do
      @invite_email.destroy
      User.find_by_id(@recipient.id).should_not be_nil
    end
  end

  describe 'validations' do
    it { should allow_value('').for(:recipient_fullname) }
    it { should validate_uniqueness_of(:recipient_email) }
    it { should ensure_inclusion_of(:sent).in_array [true, false] }
  end

  describe 'prefill_fields filter' do
    it 'should fill in Joblr team as author before validation' do
      invite_email = InviteEmail.new @attr
      invite_email.should be_valid
      invite_email.author_fullname.should == 'Joblr'
      invite_email.author_email.should == 'postman@joblr.co'
      invite_email.recipient_fullname.should == 'Unknown'
    end
  end

  describe 'make_code filter' do
    it 'should make an invitation code before validation' do
      invite_email = InviteEmail.new @attr
      invite_email.should be_valid
      invite_email.code.should_not be_nil
    end
  end

  describe 'update_users_email filter' do

    context 'for users who already have an email address' do
      it 'should not update it when invitation gets used' do
        invite_email           = InviteEmail.create! @attr
        invite_email.recipient = @recipient
        invite_email.used      = true
        invite_email.save
        @recipient.email.should_not == invite_email.recipient_email
      end
    end

    context "for users don't have an email address yet" do
      it 'should update the users email address when invitation gets used' do
        @recipient.update_attributes email: nil
        invite_email           = InviteEmail.create! @attr
        invite_email.recipient = @recipient
        invite_email.used      = true
        invite_email.save
        @recipient.email.should == invite_email.recipient_email
      end
    end
  end
end
