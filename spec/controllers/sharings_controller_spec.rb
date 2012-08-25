require 'spec_helper'

describe SharingsController do

	render_views

	before :each do
		@author = FactoryGirl.create :user
		sign_in @author
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

	describe "POST 'create'" do

		before :each do
      @author.profiles.create @profile_attr
		end

    it { response.should be_success }

    context 'user typed an email address' do

			it 'should create a new sharing object' do
				lambda do
					post :create, :sharing => @sharing_attr, :email => "test@test.com"
				end.should change(Sharing,:count).by 1
			end

	    it "should redirect to user's profile" do
	    	post :create, :sharing => @sharing_attr, :email => "test@test.com"
	    	response.should redirect_to @author
	    end
    end

    context "user didn't type an email address" do

			it 'should not create a new sharing object' do
				lambda do
					post :create, :sharing => @sharing_attr
				end.should_not change(Sharing,:count).by 1
			end

	    it "should redirect to user's profile" do
	    	post :create, :sharing => @sharing_attr
	    	response.should redirect_to new_sharing_path(id: @author.id)
	    end
    end
	end
end