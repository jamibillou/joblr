# == Schema Information
#
# Table name: emails
#
#  id                 :integer          not null, primary key
#  recipient_id       :integer
#  code               :string(255)
#  recipient_email    :string(255)
#  sent               :boolean          default(FALSE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  author_fullname    :string(255)
#  author_email       :string(255)
#  recipient_fullname :string(255)
#  cc                 :string(255)
#  bcc                :string(255)
#  reply_to           :string(255)
#  subject            :string(255)
#  status             :string(255)
#  type               :string(255)
#  page               :string(255)
#  text               :text
#  used               :boolean          default(FALSE)
#  profile_id         :integer
#  author_id          :integer
#

require 'spec_helper'

describe ToUserEmail do

  before :each do
    @recipient     = FactoryGirl.create :recipient
    @to_user_email = FactoryGirl.create :to_user_email, recipient: @recipient
  end

  it 'should inherit To the Email model' do
    ToUserEmail.should < Email
  end

  describe 'Recipient association' do

    it { @to_user_email.should respond_to :recipient }

    it 'should have the right associated recipient' do
      @to_user_email.recipient_id.should == @recipient.id
      @to_user_email.recipient.should    == @recipient
    end

    it 'should not destroy the associated recipient' do
      @to_user_email.destroy
      User.find_by_id(@to_user_email.recipient_id).should_not be_nil
    end
  end
end
