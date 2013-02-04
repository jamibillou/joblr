require 'spec_helper'

describe UsersController do

  render_views

  before :each do
    @user        = FactoryGirl.create :user, subdomain: 'jdoe', email: nil
    @profile     = FactoryGirl.create :profile, user: @user
    @user2       = FactoryGirl.create :user, fullname: FactoryGirl.generate(:fullname), username: FactoryGirl.generate(:username), email: FactoryGirl.generate(:email)
    @attr        = { fullname: 'Tony Leung', city: 'Hong Kong', country: 'China', profiles_attributes: { '0' => {experience: '10', education: 'none'} } }
    sign_in @user
  end

  describe "GET 'show'" do

    context 'for public users' do

      before :each do
        sign_out @user
      end

      context 'requests without a subdomain' do

        context 'for non-completed profiles' do

          it 'should render the 404 error page' do
            @user.profile.destroy
            expect { get :show, id: @user }.to raise_error(ActionController::RoutingError)
            response.should render_template(controller: 'errors', action: 'error_404')
          end
        end

        context 'for completed profiles' do

          before :each do
            get :show, id: @user
          end

          it { response.should be_success }

          it 'should have a the right user profile' do
            response.body.should have_selector "div#user-#{@user.id}"
          end

          it 'should have a contact button' do
            response.body.should have_content I18n.t('users.show.contact')
          end

          it 'should have a share button' do
            response.body.should have_content I18n.t('users.show.share')
          end

          it 'should have a profile email modal' do
            response.body.should have_selector '#profile-email-modal'
          end

          it 'should have the right mixpanel event' do
            response.body.should have_content "mixpanel.track('Viewed profile', {'User type': 'Public user'})"
          end
        end
      end
    end

    context 'for signed in users' do

      context "who haven't completed their profile" do

        it "should redirect to root path (profile edit)" do
          @user.profile.destroy
          get :show, id: @user
          response.should redirect_to root_path
          flash[:error].should be_nil
        end
      end

      context 'who have completed their profile' do

        before :each do
          sign_in @user
          get :show, id: @user
        end

        it { response.should be_success }

        it 'should have a the right user profile' do
          response.body.should have_selector "div#user-#{@user.id}"
        end

        it 'should have an edit button' do
          response.body.should have_content I18n.t('users.show.edit')
        end

        it 'should not have a profile email modal' do
          response.body.should_not have_selector '#profile-email-modal'
        end

        it 'should not have a mixpanel event' do
          response.body.should_not have_content "mixpanel.track"
        end

        context "and are visiting another user's profile" do

          before :each do
            sign_out @user
            sign_in  @user2
            get :show, id: @user
          end

          it 'should have the right mixpanel event' do
            response.body.should have_content "mixpanel.track('Viewed profile', {'User type': 'Other user'})"
          end
        end
      end
    end
  end

  describe "GET 'edit'" do

    context 'for public users' do

      it 'should redirect to the root path' do
        sign_out @user
        get :edit, id: @user
        response.should redirect_to root_path
        flash[:error].should == I18n.t('flash.error.only.signed_in')
      end
    end

    context 'for incorrect users' do

      it 'should redirect to the profile of the root path' do
        sign_out @user
        sign_in @user2
        get :edit, id: @user
        response.should redirect_to root_path
        flash[:error].should == I18n.t('flash.error.other_user.profile')
      end
    end

    context 'for correct users' do

      before :each do
        sign_in @user
      end

      context "who haven't completed their profile" do

        before :each do
          @user.profile.destroy
          get :edit, id: @user
        end

        it { response.should be_success }

        it 'should have an activation bar' do
          response.body.should have_selector '#activation-bar'
          response.body.should have_content I18n.t('activation.title_2')
        end

        it 'should have the right edit form' do
          response.body.should have_selector "#edit_user_#{@user.id}"
        end

        it 'should have a linkedin button' do
          response.body.should have_content I18n.t('users.edit.import_from')
          response.body.should have_content I18n.t('users.edit.linkedin')
        end

        it 'should have an save button' do
          response.body.should have_content I18n.t('users.edit.save')
        end

        context "just after signing up manually" do

          it 'should have the right mixpanel event' do
            visit new_user_registration_path
            fill_in 'user_fullname', with: 'New User'
            fill_in 'user_username', with: 'new_user'
            fill_in 'user_email',    with: 'new_user@example.com'
            fill_in 'user_password', with: 'password'
            fill_in 'user_password_confirmation', with: 'password'
            click_button I18n.t('devise.registrations.sign_up')
            page.body.should have_content "mixpanel.track('Signed up', {'Signup type': 'Manual'})"
          end
        end

        context "just after using social_signup" do

          it 'should have the right mixpanel event' do
            request.env['omniauth.auth'] = OmniAuth.config.add_mock(:twitter, {:uid => '123456'})
            visit sign_up_path
            visit user_omniauth_authorize_path('twitter')
            fill_in 'user_fullname', with: 'New User'
            fill_in 'user_username', with: 'new_user'
            fill_in 'user_email',    with: 'new_user@example.com'
            click_button I18n.t('devise.registrations.sign_up')
            page.body.should have_content "mixpanel.track('Signed up', {'Signup type': 'Social'})"
          end
        end
      end

      context 'who have completed their profile' do

        before :each do
          get :edit, id: @user
        end

        it { response.should be_success }

        it 'should not have an activation bar' do
          response.body.should_not have_selector '#activation-bar'
          response.body.should_not have_content I18n.t('activation.title_2')
        end

        it 'should have the right edit form' do
          response.body.should have_selector "#edit_user_#{@user.id}"
        end

        it 'should have an save button' do
          response.body.should have_content I18n.t('users.edit.save')
        end

        it 'should have a cancel button' do
          response.body.should have_content I18n.t('cancel')
        end
      end
    end
  end

  describe "PUT 'update'" do

    context 'for public users' do

      it 'should redirect to the root path' do
        sign_out @user
        put :update, user: @attr, id: @user
        response.body.should redirect_to root_path
        flash[:error].should == I18n.t('flash.error.only.signed_in')
      end
    end

    context 'for incorrect users' do

      it 'should redirect to the profile of the root path' do
        sign_out @user
        sign_in @user2
        put :update, user: @attr, id: @user
        response.body.should redirect_to root_path
        flash[:error].should == I18n.t('flash.error.other_user.profile')
      end
    end

    context 'for correct users' do

      context "who haven't completed their profile" do

        before :each do
          @user.profile.destroy
        end

        context "and filled in all required fields" do
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

          it 'should create a new profile' do
            lambda do
              put :update, user: @attr, id: @user
            end.should change(Profile, :count).by(1)
          end

          it "should redirect to the new_profile_email_path" do
            put :update, user: @attr, id: @user
            response.should redirect_to new_profile_email_path(mixpanel_profile_created: true)
          end
        end

        context "and failed filling in one or more required fields" do

          it "should not have an error message" do
            put :update, user: { fullname: '', city: 'Hong Kong', country: 'China', profiles_attributes: { '0' => {experience: '10', education: 'none'} } }, id: @user
            flash[:error].should == errors('user.fullname', 'blank')
          end
        end
      end

      context 'who have completed their profile' do

        before :each do
          @attr[:profiles_attributes] = [ @attr[:profiles_attributes]['0'].merge(id: @user.profile.id) ]
        end

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

        it 'should update the profile' do
          put :update, user: @attr, id: @user
          updated_user = assigns(:user)
          @user.reload
          @user.profile.experience.should == updated_user.profile.experience
        end

        it 'should not create a new profile' do
          lambda do
            put :update, user: @attr, id: @user
          end.should_not change(Profile, :count)
        end

        it "should redirect to the 'show' page with a profile updated message" do
          put :update, user: @attr, id: @user
          response.should redirect_to @user
          flash[:success].should == I18n.t('flash.success.profile.updated')
        end

        context "and failed filling in one or more required fields" do

          it "should have an error message" do
            put :update, user: { fullname: '', city: 'Hong Kong', country: 'China', profiles_attributes: { '0' => {experience: '10', education: 'none'} } }, id: @user
            flash[:error].should == errors('user.fullname', 'blank')
          end
        end
      end
    end
  end

  describe "DESTROY 'delete'" do

    context 'for public users' do

      before :each do
        sign_out @user
      end

      it 'should redirect to the root path' do
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

    context 'for non-admin users' do

      it 'should redirect to the root path' do
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

      it 'should destroy the user' do
        lambda do
          delete :destroy, id: @user
        end.should change(User, :count).by -1
      end

      it 'should redirect to the admin page' do
        delete :destroy, id: @user
        response.should redirect_to admin_path
        flash[:success].should == I18n.t('flash.success.user.destroyed')
      end
    end
  end
end