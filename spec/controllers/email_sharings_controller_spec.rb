require 'spec_helper'

describe EmailSharingsController do

	render_views

	before :each do

		@author    = FactoryGirl.create :user
		@profile_attr = { headline: 'fulltime',
                      experience: '5 yrs',
                      last_job: 'Financial director',
                      past_companies: 'Cathay Pacific, Bank of China',
                      education: 'Master of Business Administration',
                      skill_1: 'Financial control',
                      skill_2: 'Business analysis',
                      skill_3: 'Strategic decision making',
                      skill_1_level: 'Expert',
                      skill_2_level: 'Beginner',
                      skill_3_level: 'Intermediate',
                      quality_1: 'Drive',
                      quality_2: 'Work ethics',
                      quality_3: 'Punctuality',
                      text: 'Do or do not, there is no try.' }
    @email_sharing_attr = { text: "Hi, I'm really keen to work for your company and would love to go over a few ideas together soon."}
    @email_sharing_public_attr = { text: "Hi, I'm really keen to work for your company and would love to go over a few ideas together soon."}
	end

	describe "POST 'create'" do

		context 'for signed in users' do

			before :each do
				sign_in @author
	      @author.profiles.create @profile_attr
			end

	    context 'who provided an email address and full name' do

				it 'should create a new email_sharing object' do
					lambda do
						xhr :post, :create, :email_sharing => @email_sharing_attr.merge(recipient_email: 'test@test.com', recipient_fullname: 'Test Dude'), user_id: @author.id
					end.should change(EmailSharing, :count).by 1
				end

		    it "should redirect to user's profile" do
		    	xhr :post, :create, :email_sharing => @email_sharing_attr.merge(recipient_email: 'test@test.com', recipient_fullname: 'Test Dude'), user_id: @author.id
		    	#response.should redirect_to @author
		    	flash[:success].should == I18n.t('flash.success.profile.shared', recipient_email: 'test@test.com')
		    end
	    end

	    context "who didn't provide email address" do

				it 'should not create a new email_sharing object' do
					lambda do
						xhr :post, :create, :email_sharing => @email_sharing_attr.merge(recipient_fullname: 'Test Dude'), user_id: @author.id
					end.should_not change(EmailSharing, :count).by 1
				end

		    it 'should have an error messsage' do
		    	xhr :post, :create, :email_sharing => @email_sharing_attr.merge(recipient_fullname: 'Test Dude'), user_id: @author.id
		    	response.body.should == I18n.t('flash.error.required.all')
		    end
	    end

	    context "who didn't provide any full name" do

	      it 'should not create a new email_sharing object' do
	        lambda do
	          xhr :post, :create, :email_sharing => @email_sharing_attr.merge(recipient_email: 'test@test.com'), user_id: @author.id
	        end.should_not change(EmailSharing, :count).by 1
	      end

	      it 'should have an error messsage' do
	        xhr :post, :create, :email_sharing => @email_sharing_attr.merge(recipient_email: 'test@test.com'), user_id: @author.id
	        response.body.should == I18n.t('flash.error.required.all')
	      end
	    end
		end

		context 'for public visitors' do

			before :each do
	      @author.profiles.create @profile_attr
			end

	    context 'who provided all info' do

				it 'should create a new email_sharing object' do
					lambda do
						xhr :post, :create, :email_sharing => @email_sharing_attr.merge(author_email: 'author@example.com', author_fullname: 'The Author', recipient_email: 'test@test.com', recipient_fullname: 'Test Dude'), user_id: @author.id
					end.should change(EmailSharing, :count).by 1
				end

		    it "should render user's profile" do
		    	xhr :post, :create, :email_sharing => @email_sharing_attr.merge(author_email: 'author@example.com', author_fullname: 'The Author', recipient_email: 'test@test.com', recipient_fullname: 'Test Dude'), user_id: @author.id
		    	#response.should redirect_to @author
		    	flash[:success].should == I18n.t('flash.success.profile.shared', recipient_email: 'test@test.com')
		    end
	    end

	    context "who didn't provide an author email address" do

				it 'should not create a new email_sharing object' do
					lambda do
						xhr :post, :create, :email_sharing => @email_sharing_attr.merge(author_fullname: 'The Author', recipient_email: 'test@test.com', recipient_fullname: 'Test Dude'), user_id: @author.id
					end.should_not change(EmailSharing, :count).by 1
				end

		    it 'should have an error messsage' do
		    	xhr :post, :create, :email_sharing => @email_sharing_attr.merge(author_fullname: 'The Author', recipient_email: 'test@test.com', recipient_fullname: 'Test Dude'), user_id: @author.id
		    	response.body.should == I18n.t('flash.error.required.all')
		    end
	    end

	    context "who didn't provide an author full name" do

	      it 'should not create a new email_sharing object' do
	        lambda do
	          xhr :post, :create, :email_sharing => @email_sharing_attr.merge(author_email: 'author@example.com', recipient_email: 'test@test.com', recipient_fullname: 'Test Dude'), user_id: @author.id
	        end.should_not change(EmailSharing, :count).by 1
	      end

	      it 'should have an error messsage' do
	        xhr :post, :create, :email_sharing => @email_sharing_attr.merge(author_email: 'author@example.com', recipient_email: 'test@test.com', recipient_fullname: 'Test Dude'), user_id: @author.id
		    	response.body.should == I18n.t('flash.error.required.all')
	      end
	    end

	    context "who didn't provide a recipient email" do

	      it 'should not create a new email_sharing object' do
	        lambda do
	          xhr :post, :create, :email_sharing => @email_sharing_attr.merge(author_fullname: 'The Author', author_email: 'author@example.com', recipient_fullname: 'Test Dude'), user_id: @author.id
	        end.should_not change(EmailSharing, :count).by 1
	      end

	      it 'should have an error messsage' do
	        xhr :post, :create, :email_sharing => @email_sharing_attr.merge(author_fullname: 'The Author', author_email: 'author@example.com', recipient_fullname: 'Test Dude'), user_id: @author.id
		    	response.body.should == I18n.t('flash.error.required.all')
	      end
	    end

	    context "who didn't provide a recipient full name" do

	      it 'should not create a new email_sharing object' do
	        lambda do
	          xhr :post, :create, :email_sharing => @email_sharing_attr.merge(author_fullname: 'The Author', author_email: 'author@example.com', recipient_email: 'test@test.com'), user_id: @author.id
	        end.should_not change(EmailSharing, :count).by 1
	      end

	      it 'should have an error messsage' do
	        xhr :post, :create, :email_sharing => @email_sharing_attr.merge(author_fullname: 'The Author', author_email: 'author@example.com', recipient_email: 'test@test.com'), user_id: @author.id
		    	response.body.should == I18n.t('flash.error.required.all')
	      end
	    end
		end
	end
end