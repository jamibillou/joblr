require 'spec_helper'

describe UsersController do

  render_views

  before :each do
    @user = FactoryGirl.create :user
    sign_in @user
    @attr =         { fullname: 'Tony Leung', city: 'Hong Kong', country: 'China', profiles_attributes: { '0' => { headline: 'fulltime', experience: '10', education: 'none', text: 'A good and highly motivated guy.' } } }
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
    @beta_invite = FactoryGirl.create :beta_invite, user: nil
  end

  describe "GET 'show'" do

    context 'for signed in users' do

      context "who haven't completed their profile" do
        it "should redirect to 'edit'" do
          get :show, id: @user
          response.should redirect_to edit_user_path(@user)
        end
      end

      context "who have completed their profile" do

        before :each do
          @user.profiles.create @profile_attr
          get :show, id: @user
        end

        it { response.should be_success }

        it 'should have a the right user profile' do
          response.body.should have_selector "div#user-#{@user.id}"
        end

        it 'should have a div with the email-sharing modal' do
          response.body.should have_selector 'div#email-sharing-form'
        end
      end
    end

    context 'for public visitors' do

      before(:each) do
        sign_out @user
        @user.profiles.create @profile_attr
        get :show, id: @user
      end

      context 'requests without a subdomain' do

        it 'should have the right user profile' do
          response.body.should have_selector "div#user-#{@user.id}"
        end

        it 'should have a div with the email-sharing modal' do
          response.body.should have_selector 'div#email-sharing-form'
        end
      end

      context 'requests with an existing subdomain' # do
        it 'should have the right user profile' do
        # end
      end

      context 'requests with non-existing subdomains' do

        it 'should have an error 500' # do
        # end
      end
    end
  end

  describe "GET 'edit'" do

    before :each do
      get :edit, id: @user
    end

    it { response.should be_success }

    it 'should have an edit form' do
      response.body.should have_selector "form.edit_user#edit_user_#{@user.id}"
    end
  end

  describe "PUT 'update'" do

    it 'should update the user' do
      put :update, user: @attr, id: @user
      updated_user = assigns :user
      @user.reload
      @user.fullname.should == updated_user.fullname
    end

    it 'should not create a new user' do
      lambda do
        put :update, user: @attr, id: @user
      end.should_not change(User, :count)
    end

    it 'should create a profile' do
      lambda do
        put :update, user: @attr, id: @user
      end.should change(Profile, :count).by(1)
    end

    it "should redirect to the 'show' page" do
      put :update, user: @attr, id: @user
      response.should redirect_to @user
    end

    context 'for users who signed up with a beta_invite' do

      before(:each) { session[:beta_invite] = @beta_invite }

      it 'should associate the user and the beta_invite' do
        put :update, user: @attr, id: @user
        @user.beta_invite.id.should == @beta_invite.id
        @user.beta_invite.should == @beta_invite
      end

      it "should update the user's email if he didn't have one !!! FIX ME !!!" # do
      #   put :update, user: @attr, id: @user
      #   @user.email.should == @beta_invite.email
      # end

      it "should not update the user's email if he already had one" do
        @user.update_attributes email: 'user@example.com'
        put :update, user: @attr, id: @user
        @user.email.should_not == @beta_invite.email
      end

      it 'should destroy the session' do
        put :update, user: @attr, id: @user
        session[:beta_invite].should be_nil
      end
    end
  end
end