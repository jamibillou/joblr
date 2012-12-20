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
#  reply_to           :string(255)
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
    @recipient            = FactoryGirl.create :recipient, email: nil
    @invite_email         = FactoryGirl.create :invite_email, recipient: nil
    @used_invite_email    = FactoryGirl.create :invite_email, recipient_email: FactoryGirl.generate(:email), recipient: @recipient
    @attr                 = {recipient_email: FactoryGirl.generate(:email)}
  end

  it 'should inherit from the ToUserEmail model' do
    InviteEmail.should < ToUserEmail
  end

  describe 'recipient association' do

    it { @invite_email.should respond_to :recipient }

    it 'should have the right associated recipient' do
      @used_invite_email.recipient_id.should == @recipient.id
      @used_invite_email.recipient.should == @recipient
    end

    it 'should not destroy the associated recipient' do
      @used_invite_email.destroy
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

  describe 'use_invite(user) method' do

    before :each do
      @used_invite_email.destroy
    end

    context 'for users who already have an email address' do

      before :each do
        @recipient.update_attributes email: FactoryGirl.generate(:email)
        @invite_email.use_invite(@recipient)
      end

      it "should not update the user's email address" do
        @recipient.email.should_not == @invite_email.recipient_email
      end

      it 'should associate the invite_email and user' do
        @recipient.invite_email.id.should == @invite_email.id
        @recipient.invite_email.should == @invite_email
      end

      it 'should set the invte_email to used' do
        @invite_email.should be_used
      end
    end

    context "for users don't have an email address yet" do

      before :each do
        @invite_email.use_invite(@recipient)
      end

      it "should update the user's email address when invitation gets used" do
        @recipient.email.should == @invite_email.recipient_email
      end

      it 'should associate the invite_email and user' do
        @recipient.invite_email.id.should == @invite_email.id
        @recipient.invite_email.should == @invite_email
      end

      it 'should set the invte_email to used' do
        @invite_email.should be_used
      end
    end
  end
end
