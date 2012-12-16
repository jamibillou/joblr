require 'spec_helper'

describe UserEmail do

  before :each do
    @author     = FactoryGirl.create :user
    @user_email = FactoryGirl.create :user_email, author: @author
  end

  it 'should inherit from the Email model' do
    UserEmail.should < Email
  end

  describe 'Author association' do

    it { @user_email.should respond_to :author }

    it 'should have the right associated author' do
      @user_email.author_id.should == @author.id
      @user_email.author.should    == @author
    end

    it 'should not destroy the associated author' do
      @user_email.destroy
      User.find_by_id(@user_email.author_id).should_not be_nil
    end
  end
end
