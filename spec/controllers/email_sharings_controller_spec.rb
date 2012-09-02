require 'spec_helper'

describe EmailSharingsController do

	render_views

	before :each do
		@author = FactoryGirl.create :user
		@recipient = FactoryGirl.create :user, username: FactoryGirl.generate(:username), fullname: FactoryGirl.generate(:fullname)
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

		context 'registered user: ' do

			before :each do
				sign_in @author
			end

	    context "user hasn't completed his profile" do

	      context "no user id is provided" do
	        it "should redirect to 'edit'" do
	          get :new
	          response.should redirect_to edit_user_path(@author)
	        end
	      end

	      it "should redirect to 'edit'" do
	        get :new, id: @author.id
	        response.should redirect_to edit_user_path(@author)
	      end
	    end

	    context 'user has completed his profile' do

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

		    it 'should have a card with the author profile' do
	        get :new, id: @author.id
		    	response.body.should have_selector 'div', class:'card', id:"show-user-#{@author.id}"
		    end
	    end
		end

		context 'unregistered user: ' do

	    context "selected user hasn't completed his profile" do

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

	    context 'selected user has completed his profile' do

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

		    it 'should have a card with the selected user profile' do
	        get :new, id: @author.id
		    	response.body.should have_selector 'div', class:'card', id:"show-user-#{@author.id}"
		    end
	    end
		end
	end

	describe "POST 'create'" do

		context 'registered user: ' do
			before :each do
				sign_in @author
	      @author.profiles.create @profile_attr
			end

	    it { response.should be_success }

	    context 'user typed an email address and a fullname' do

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

	    context "user didn't fill in any email address" do

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

	    context "user didn't fill in any fullname" do

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

		context 'unregistered user: ' do
			before :each do
	      @author.profiles.create @profile_attr
			end

	    it { response.should be_success }

	    context 'user filled every fields' do

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

	    context "user didn't fill in the author email address" do

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

	    context "user didn't fill in the author fullname" do

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

	    context "user didn't fill in the recipient email" do

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

	    context "user didn't fill in the recipient fullname" do

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
