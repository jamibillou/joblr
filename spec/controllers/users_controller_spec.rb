require 'spec_helper'

describe UsersController do

  render_views

  before :each do
    @user  = FactoryGirl.create :user, subdomain: 'jdoe', email: nil
    @user2 = FactoryGirl.create :user, fullname: FactoryGirl.generate(:fullname), username: FactoryGirl.generate(:username), email: FactoryGirl.generate(:email)
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
          flash[:error].should == I18n.t('flash.error.only.signed_up')
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
      end  

      context 'requests without a subdomains' do
        before :each do
          get :show, id: @user
        end 

        it 'should have the right user profile' do
          response.body.should have_selector "div#user-#{@user.id}"
        end

        it 'should have a div with the email-sharing modal' do          
          response.body.should have_selector 'div#email-sharing-form'
        end
      end

      context 'requests with existing subdomains' do
        #it 'should have the right user profile' do
          ### To be completed
          #response.body.should have_selector "div#user-#{@user.id}"
        #end
      end

      context 'requests with non-existing subdomains' do
        #it 'should redirect to 404 page'  do
          ### Te be completed
          #response.should render_template '/404'
        #end
      end
    end
  end

  describe "GET 'edit'" do

    context 'from the correct user' do
      before :each do
        get :edit, id: @user
      end

      it { response.should be_success }

      it 'should have an edit form' do
        response.body.should have_selector "form.edit_user#edit_user_#{@user.id}"
      end
    end

    context 'from another user' do

      before :each do
        sign_out @user
        sign_in @user2
        get :edit, id: @user
      end

      it 'should redirect to the connected user profile' do
        response.body.should redirect_to root_path
        flash[:error].should == I18n.t('flash.error.other_user.profile')
      end 
    end

    context 'from a public visitor' do

      before :each do
        sign_out @user
        get :edit, id: @user
      end

      it 'should redirect to the root path' do
        response.body.should redirect_to root_path
        flash[:error].should == I18n.t('flash.error.other_user.profile')
      end 
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
      flash[:success].should == I18n.t('flash.success.profile.created')
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

  describe "DESTROY 'delete'" do

    context 'for public users' do
      before :each do
        sign_out @user
      end

      it 'should redirect to root path' do
        delete :destroy, id: @user
        response.should redirect_to root_path
        flash[:error].should == I18n.t('flash.error.only.admin')
      end

      it 'should not delete the user' do
        lambda do
          delete :destroy, id: @user
        end.should_not change(User, :count).by 1
      end
    end

    context 'for public users' do
      before :each do
        sign_out @user
      end

      it 'should redirect to root path' do
        delete :destroy, id: @user
        response.should redirect_to root_path
        flash[:error].should == I18n.t('flash.error.only.admin')
      end

      it 'should not destroy the user' do
        lambda do
          delete :destroy, id: @user
        end.should_not change(User, :count).by 1
      end
    end

    context 'for admins' do
      before :each do
        @user.toggle! :admin
      end

      it 'should not destroy the user' do
        lambda do
          delete :destroy, id: @user
        end.should change(User, :count).by -1
      end

      it 'should redirect_to admin path' do
        delete :destroy, id: @user
        response.should redirect_to admin_path
        flash[:success].should == I18n.t('flash.success.user.destroyed')
      end 
    end    
  end
end