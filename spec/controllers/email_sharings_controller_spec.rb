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

	describe "GET 'new'" do

		context 'for signed in users' do

			before :each do
				sign_in @author
			end

	    context "who haven't completed their profile" do

        it "should redirect to 'edit'" do
          get :new
          response.should redirect_to edit_user_path(@author)
        end

	      it "should redirect to 'edit'" do
	        get :new, id: @author.id
	        response.should redirect_to edit_user_path(@author)
	      end
	    end

	    context 'who have completed their profile' do

	      before(:each) { @author.profiles.create @profile_attr }

	      context "no user id is provided" do
	        it "should be http success" do
	          get :new
	          response.should be_success
	        end
	      end

		    it "should be http success" do
	        get :new, id: @author.id
	        response.should be_success
	      end

		    it "should have the author's profile" do
	        get :new, id: @author.id
		    	response.body.should have_selector "div#user-#{@author.id}"
		    end
	    end
		end

		context 'for public visitors' do

	    context "who visit a profile that wasn't completed" do

	      context "no user id is provided" do
	        it "should redirect to the root path" do
	          get :new
	          response.should redirect_to root_path
	        end
	      end

	      it "should redirect to the root path" do
	        get :new, id: @author.id
	        response.should redirect_to root_path
	      end
	    end

	    context "who visit a profile that was completed" do

	      before(:each) { @author.profiles.create @profile_attr }

	      context "no user id is provided" do
	        it "should redirect to the root path" do
	          get :new
	          response.should redirect_to root_path
	        end
	      end

		    it "should be http success" do
	        get :new, id: @author.id
	        response.should be_success
	      end

		    it 'should have the visited profile' do
	        get :new, id: @author.id
		    	response.body.should have_selector "div#user-#{@author.id}"
		    end
	    end
		end
	end

	describe "POST 'create'" do

		context 'for signed in users' do
			before :each do
				sign_in @author
	      @author.profiles.create @profile_attr
			end

	    it { response.should be_success }

	    context 'who provided an email address and full name' do

				it 'should create a new email_sharing object' do
					lambda do
						post :create, :email_sharing => @email_sharing_attr.merge(recipient_email: 'test@test.com', recipient_fullname: 'Test Dude'), user_id: @author.id
					end.should change(EmailSharing,:count).by 1
				end

		    it "should redirect to user's profile" do
		    	post :create, :email_sharing => @email_sharing_attr.merge(recipient_email: 'test@test.com', recipient_fullname: 'Test Dude'), user_id: @author.id
		    	response.should redirect_to @author
		    end
	    end

	    context "who didn't provide email address" do

				it 'should not create a new email_sharing object' do
					lambda do
						post :create, :email_sharing => @email_sharing_attr.merge(recipient_fullname: 'Test Dude'), user_id: @author.id
					end.should_not change(EmailSharing,:count).by 1
				end

		    it "should redirect to user's profile" do
		    	post :create, :email_sharing => @email_sharing_attr.merge(recipient_fullname: 'Test Dude'), user_id: @author.id
		    	response.should render_template('new',id: @author.id)
		    end
	    end

	    context "who didn't provide any full name" do

	      it 'should not create a new email_sharing object' do
	        lambda do
	          post :create, :email_sharing => @email_sharing_attr.merge(recipient_email: 'test@test.com'), user_id: @author.id
	        end.should_not change(EmailSharing,:count).by 1
	      end

	      it "should redirect to user's profile" do
	        post :create, :email_sharing => @email_sharing_attr.merge(recipient_email: 'test@test.com'), user_id: @author.id
	        response.should render_template('new',id: @author.id)
	      end
	    end
		end

		context 'for public visitors' do
			before :each do
	      @author.profiles.create @profile_attr
			end

	    it { response.should be_success }

	    context 'who provided all info' do

				it 'should create a new email_sharing object' do
					lambda do
						post :create, :email_sharing => @email_sharing_attr.merge(author_email: 'author@example.com', author_fullname: 'The Author', recipient_email: 'test@test.com', recipient_fullname: 'Test Dude'), user_id: @author.id
					end.should change(EmailSharing,:count).by 1
				end

		    it "should redirect to user's profile" do
		    	post :create, :email_sharing => @email_sharing_attr.merge(author_email: 'author@example.com', author_fullname: 'The Author', recipient_email: 'test@test.com', recipient_fullname: 'Test Dude'), user_id: @author.id
		    	response.should redirect_to @author
		    end
	    end

	    context "who didn't provide an author email address" do

				it 'should not create a new email_sharing object' do
					lambda do
						post :create, :email_sharing => @email_sharing_attr.merge(author_fullname: 'The Author', recipient_email: 'test@test.com', recipient_fullname: 'Test Dude'), user_id: @author.id
					end.should_not change(EmailSharing,:count).by 1
				end

		    it "should redirect to user's profile" do
		    	post :create, :email_sharing => @email_sharing_attr.merge(author_fullname: 'The Author', recipient_email: 'test@test.com', recipient_fullname: 'Test Dude'), user_id: @author.id
		    	response.should render_template('new',id: @author.id)
		    end
	    end

	    context "who didn't provide an author full name" do

	      it 'should not create a new email_sharing object' do
	        lambda do
	          post :create, :email_sharing => @email_sharing_attr.merge(author_email: 'author@example.com', recipient_email: 'test@test.com', recipient_fullname: 'Test Dude'), user_id: @author.id
	        end.should_not change(EmailSharing,:count).by 1
	      end

	      it "should redirect to user's profile" do
	        post :create, :email_sharing => @email_sharing_attr.merge(author_email: 'author@example.com', recipient_email: 'test@test.com', recipient_fullname: 'Test Dude'), user_id: @author.id
	        response.should render_template('new',id: @author.id)
	      end
	    end

	    context "who didn't provide a recipient email" do

	      it 'should not create a new email_sharing object' do
	        lambda do
	          post :create, :email_sharing => @email_sharing_attr.merge(author_fullname: 'The Author', author_email: 'author@example.com', recipient_fullname: 'Test Dude'), user_id: @author.id
	        end.should_not change(EmailSharing,:count).by 1
	      end

	      it "should redirect to user's profile" do
	        post :create, :email_sharing => @email_sharing_attr.merge(author_fullname: 'The Author', author_email: 'author@example.com', recipient_fullname: 'Test Dude'), user_id: @author.id
	        response.should render_template('new',id: @author.id)
	      end
	    end

	    context "who didn't provide a recipient full name" do

	      it 'should not create a new email_sharing object' do
	        lambda do
	          post :create, :email_sharing => @email_sharing_attr.merge(author_fullname: 'The Author', author_email: 'author@example.com', recipient_fullname: 'Test Dude'), user_id: @author.id
	        end.should_not change(EmailSharing,:count).by 1
	      end

	      it "should redirect to user's profile" do
	        post :create, :email_sharing => @email_sharing_attr.merge(author_fullname: 'The Author', author_email: 'author@example.com', recipient_fullname: 'Test Dude'), user_id: @author.id
	        response.should render_template('new',id: @author.id)
	      end
	    end
		end
	end
end
