# == Schema Information
#
# Table name: emails
#
#  id                 :integer          not null, primary key
#  recipient_id       :integer
#  code               :string(255)
#  recipient_email    :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  sent               :boolean          default(FALSE)
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
#  text               :string(255)
#  used               :boolean          default(FALSE)
#  profile_id         :integer
#  author_id          :integer
#

require 'spec_helper'

describe FromUserEmail do

  before :each do
    @author          = FactoryGirl.create :author
    @from_user_email = FactoryGirl.create :from_user_email, author: @author
  end

  it 'should inherit from the Email model' do
    FromUserEmail.should < Email
  end

  describe 'Author association' do

    it { @from_user_email.should respond_to :author }

    it 'should have the right associated author' do
      @from_user_email.author_id.should == @author.id
      @from_user_email.author.should    == @author
    end

    it 'should not destroy the associated author' do
      @from_user_email.destroy
      User.find_by_id(@from_user_email.author_id).should_not be_nil
    end
  end
end
