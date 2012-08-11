require 'spec_helper'

describe Sharing do

	before :each do
		@author    = FactoryGirl.create :user
		@recipient = FactoryGirl.create :user, username: FactoryGirl.generate(:username), fullname: FactoryGirl.generate(:fullname)
		@sharing   = FactoryGirl.create :sharing, author: @author, recipient: @recipient
	end

	describe 'author association' do

		it { @sharing.should respond_to :author }

		it 'should have the right associated author' do
			@sharing.author_id.should == @author.id
			@sharing.author.should == @author
		end

		it 'should not destroy the associated author' do
			@sharing.destroy
			User.find_by_id(@author.id).should_not be_nil
		end
	end

	describe 'recipient association' do

		it { @sharing.should respond_to :recipient }

		it 'should have the right associated recipient' do
			@sharing.recipient_id.should == @recipient.id
			@sharing.recipient.should == @recipient
		end

		it 'should not destroy the associated recipient' do
			@sharing.destroy
			User.find_by_id(@recipient.id).should_not be_nil
		end
	end

	describe 'validations' do
    it { should ensure_length_of(:text).is_at_most 140 }
    it { should validate_presence_of :text }
	end
end