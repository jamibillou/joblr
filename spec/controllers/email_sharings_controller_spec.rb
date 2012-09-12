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

		    it 'should send an email' do
					xhr :post, :create, :email_sharing => @email_sharing_attr.merge(recipient_email: 'test@test.com', recipient_fullname: 'Test Dude'), user_id: @author.id
		    	ActionMailer::Base.deliveries.last.to.should == ['test@test.com']
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
		    	flash[:success].should == I18n.t('flash.success.profile.shared', recipient_email: 'test@test.com')
		    end

		    it 'should send an email' do
					xhr :post, :create, :email_sharing => @email_sharing_attr.merge(author_email: 'author@example.com', author_fullname: 'The Author', recipient_email: 'test_public@test.com', recipient_fullname: 'Test Dude'), user_id: @author.id
		    	ActionMailer::Base.deliveries.last.to.should == ['test_public@test.com']
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

	describe "GET 'decline'" do

		before :each do
			@author.profiles.create @profile_attr
		end

		context 'from an email_sharing that had already been answered' do

			it 'should redirect to already_answered_path' do
				@email_sharing = EmailSharing.create!(@email_sharing_attr.merge(profile: @author.profile, author: nil, author_email: 'author@example.com', author_fullname: 'The author', recipient_email: 'recipient@example.com', recipient_fullname: 'The recipient', status:'declined'))
				get :decline, email_sharing_id: @email_sharing
				response.should redirect_to email_sharing_already_answered_path
			end
		end

		context "from an email_sharing that had not been answered yet" do

			before :each do
				@email_sharing = EmailSharing.create!(@email_sharing_attr.merge(profile: @author.profile, author: nil, author_email: 'author@example.com', author_fullname: 'The author', recipient_email: 'recipient@example.com', recipient_fullname: 'The recipient', status: nil))
				get :decline, email_sharing_id: @email_sharing
			end

			it { response.should be_success }

			it 'should update the status' # do
			# FIX ME!
			# 	@email_sharing.status.should == 'declined'
			# end

			it 'should have thank you message' do
				response.body.should include I18n.t('email_sharings.decline.thank_you')
			end
		end

		describe "GET 'already_answered'" do

			before :each do
        @email_sharing = EmailSharing.create!(@email_sharing_attr.merge(profile: @author.profile, author: nil, author_email: 'author@example.com', author_fullname: 'The author', recipient_email: 'recipient@example.com', recipient_fullname: 'The recipient', status:'declined'))
				get :already_answered, email_sharing_id: @email_sharing
			end

			it { response.should be_success }

			it 'should have thank you message' do
				response.body.should include I18n.t('email_sharings.already_answered.thank_you', fullname: @email_sharing.fullname)
			end
		end
	end
end