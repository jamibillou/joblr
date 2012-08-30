require 'spec_helper'

describe EmailSharing do

	before :each do
		@author    = FactoryGirl.create :user
		@profile   = FactoryGirl.create :profile, user: @author
		@sharing_registered   = FactoryGirl.create :email_sharing, profile: @profile, author: @author, author_fullname: nil, author_email: nil
		@sharing_public				= FactoryGirl.create :email_sharing, profile: @profile, author: nil
	end

	describe 'Registered author sharing' do

		describe 'Author association' do
			it { @sharing_registered.should respond_to :author }

			it 'should have the right associated author' do
				@sharing_registered.author_id.should == @author.id
				@sharing_registered.author.should    == @author
			end

			it 'should not destroy the associated author' do
				@sharing_registered.destroy
				User.find_by_id(@sharing_registered.author_id).should_not be_nil
			end
		end
	end

	describe 'Public author sharing' do
    
    before :all do
      @email = { :invalid => %w(invalid_email invalid@example invalid@user@example.com inv,alide@), :valid => %w(valid_email@example.com valid@example.co.kr vu@example.us) }
    end
		
		describe 'Validations' do
    
		it { @sharing_public.should validate_presence_of :author_fullname }
		it { @sharing_public.should ensure_length_of(:author_fullname).is_at_most 100 }
		it { @sharing_public.should validate_presence_of :author_email }

    lambda { @email[:invalid].each {|invalid_email| it { @sharing_public.should validate_format_of(:author_email).not_with invalid_email }}}
    lambda { @email[:valid].each   {|valid_email|   it { @sharing_public.should validate_format_of(:author_email).with valid_email }}}

		end
	end

	describe 'Validations for every type of sharing' do

    before :all do
      @email = { :invalid => %w(invalid_email invalid@example invalid@user@example.com inv,alide@), :valid => %w(valid_email@example.com valid@example.co.kr vu@example.us) }
    end

		it { should validate_presence_of :recipient_fullname }
		it { should ensure_length_of(:recipient_fullname).is_at_most 100 }
		it { should validate_presence_of :recipient_email }
    it { should ensure_length_of(:text).is_at_most 140 }
    it { should validate_presence_of :text }

    lambda { @email[:invalid].each {|invalid_email| it { should validate_format_of(:recipient_email).not_with invalid_email }}}
    lambda { @email[:valid].each   {|valid_email|   it { should validate_format_of(:recipient_email).with valid_email }}}

	end

end
# == Schema Information
#
# Table name: email_sharings
#
#  id                 :integer         not null, primary key
#  profile_id         :integer
#  author_id          :integer
#  author_fullname    :string(255)
#  author_email       :string(255)
#  recipient_fullname :string(255)
#  recipient_email    :string(255)
#  text               :string(255)
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#

