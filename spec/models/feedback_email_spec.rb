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

describe FeedbackEmail do

  before :each do
    @author = FactoryGirl.create :author
    @attr   = {author: @author, text: 'Lorem ipsum', page: '/'}
  end

  describe 'Validations' do
    it { should validate_presence_of :text }
    it { should validate_presence_of :page }
  end

  it 'should fill in Joblr team as recipient before validation' do
    feedback_email = FeedbackEmail.new @attr
    feedback_email.should be_valid
    feedback_email.recipient_fullname.should == 'Joblr team'
    feedback_email.recipient_email.should == 'team@joblr.co'
  end
end
