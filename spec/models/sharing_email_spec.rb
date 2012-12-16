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
#  text               :string(255)
#  status             :string(255)
#  type               :string(255)
#  profile_id         :integer
#  author_id          :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'spec_helper'

describe SharingEmail do

	before :each do
		@author    = FactoryGirl.create :user
		@profile   = FactoryGirl.create :profile, user: @author
		@sharing_email_registered   = FactoryGirl.create :sharing_email, profile: @profile, author: @author
		@sharing_email_public		= FactoryGirl.create :sharing_email, profile: @profile, author: nil
	end

	describe 'Profile association' do
		it { @sharing_email_registered.should respond_to :profile }

		it 'should have the right associated profile' do
			@sharing_email_registered.profile_id.should == @profile.id
			@sharing_email_registered.profile.should == @profile
		end

		it 'should not destroy the associated profile' do
			@sharing_email_registered.destroy
			Profile.find_by_id(@sharing_email_registered.profile_id).should_not be_nil
		end
	end

	describe 'Registered author sharing' do

		describe 'Author association' do
			it { @sharing_email_registered.should respond_to :author }

			it 'should have the right associated author' do
				@sharing_email_registered.author_id.should == @author.id
				@sharing_email_registered.author.should    == @author
			end

			it 'should not destroy the associated author' do
				@sharing_email_registered.destroy
				User.find_by_id(@sharing_email_registered.author_id).should_not be_nil
			end
		end
	end

  describe 'Validations' do

    before :all do
      @email = { :invalid => %w(invalid_email invalid@example invalid@user@example.com inv,alide@), :valid => %w(valid_email@example.com valid@example.co.kr vu@example.us) }
    end

		context 'public email sharing' do
  		it { @sharing_email_public.should validate_presence_of :author_fullname }
  		it { @sharing_email_public.should ensure_length_of(:author_fullname).is_at_most 100 }
  		it { @sharing_email_public.should validate_presence_of :author_email }
      it { should validate_format_of(:author_email).not_with(@email[:invalid][rand(@email[:invalid].size)]).with_message(I18n.t('activerecord.errors.messages.invalid')) }
      it { should validate_format_of(:author_email).with @email[:valid][rand(@email[:valid].size)] }
		end

		it { should validate_presence_of :recipient_fullname }
		it { should ensure_length_of(:recipient_fullname).is_at_most 100 }
		it { should validate_presence_of :recipient_email }
    it { should ensure_length_of(:text).is_at_most 140 }
    it { should ensure_inclusion_of(:status).in_array ['accepted', 'declined'] }
    it { should validate_presence_of :text }
    it { should validate_format_of(:recipient_email).not_with(@email[:invalid][rand(@email[:invalid].size)]).with_message(I18n.t('activerecord.errors.messages.invalid')) }
    it { should validate_format_of(:recipient_email).with @email[:valid][rand(@email[:valid].size)] }
	end
end
