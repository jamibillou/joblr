require 'spec_helper'

describe FeedbackEmail do

  before :each do
    @author = FactoryGirl.create :author
    @attr   = {author: @author, text: 'Lorem ipsum', page: '/'}
  end

  describe 'Validations' do
    it { should validate_presence_of :page }
  end

  it 'should fill in Joblr team as recipient before validation' do
    feedback_email = FeedbackEmail.new @attr
    feedback_email.should be_valid
    feedback_email.recipient_fullname.should == 'Joblr team'
    feedback_email.recipient_email.should == 'team@joblr.co'
  end
end
