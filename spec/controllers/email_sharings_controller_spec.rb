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
    @sharing_attr = {author_id: @author.id, text: "Hi, I'm really keen to work for your company and would love to go over a few ideas together soon."}
	end

	describe "GET 'new'" do

		context "registered user" do

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

		context 'Unregistered user' do

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
end
