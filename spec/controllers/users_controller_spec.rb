require 'spec_helper'

describe UsersController do

  render_views

  before :each do
    @user        = FactoryGirl.create :user, subdomain: 'jdoe', email: nil
    @profile     = FactoryGirl.create :profile, user: @user
    @user2       = FactoryGirl.create :user, fullname: FactoryGirl.generate(:fullname), username: FactoryGirl.generate(:username), email: FactoryGirl.generate(:email)
    @attr        = { fullname: 'Tony Leung', city: 'Hong Kong', country: 'China', profiles_attributes: { '0' => { headline: 'fulltime', experience: '10', education: 'none', text: 'A good and highly motivated guy.' } } }
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
            visit user_path(@user)
          end

          it { response.should be_success }

          it 'should have a the right user profile' do
            find("div#user-#{@user.id}").should have_content @user.fullname
          end

          it 'should have an edit button with a primary style' do
            find('a.btn.btn-primary').should have_content I18n.t('users.show.contact')
          end

          it 'should have a send button' do
            find('a.btn.btn-default').should have_content I18n.t('users.show.send')
          end

          it 'should have a profile email modal' do
            find('div#profile-email-modal').should have_content I18n.t('profile_emails.new.title')
          end

          it 'should have kissmetrics event' do
            get :show, id: @user
            response.body.should have_content "_kmq.push(['record', 'Viewed profile (public user)'])"
          end
        end
      end

      context 'requests with non-existing subdomains' do

        it 'should render the 404 error page' # do
          # FIX ME!
          # expect { visit bla }.to raise_error(ActionController::RoutingError)
          # response.should render_template(controller: 'errors', action: 'error_404')
        # end
      end

      context 'requests with an existing user subdomain' do

        context "and a path other than '/'" do

          it 'should render the 404 error page' # do
            # FIX ME!
            # expect { visit bla }.to raise_error(ActionController::RoutingError)
            # response.should render_template(controller: 'errors', action: 'error_404')
          # end
        end

        context "and '/' as path" do

          it 'should have the right user profile' # do
            # FIX ME!
            # visit bla
            # find("div#user-#{@user.id}").should have_content @user.fullname
          # end
        end
      end

      context 'requests with staging.joblr.co as a host' do

        context "and a path other than '/'" do

          it 'should have the right content' # do
            # FIX ME!
            # visit bla
            # response.should render_template(controller: 'whatever', action: 'whatever')
          # end
        end

        context "and '/' as path" do

          it 'should have the right content' # do
            # FIX ME!
            # visit bla
            # response.should render_template(controller: 'whatever', action: 'whatever')
          # end
        end
      end

      context 'requests with joblr-staging.herokuapp.com as host' do

        context "and a path other than '/'" do

          it 'should have the right content' # do
            # FIX ME!
            # visit bla
            # response.should render_template(controller: 'whatever', action: 'whatever')
          # end
        end

        context "and '/' as path" do

          it 'should have the right content' # do
            # FIX ME!
            # visit bla
            # response.should render_template(controller: 'whatever', action: 'whatever')
          # end
        end
      end

      context 'requests with joblr.herokuapp.com as host' do

        context "and a path other than '/'" do

          it 'should have the right content' # do
            # FIX ME!
            # visit bla
            # response.should render_template(controller: 'whatever', action: 'whatever')
          # end
        end

        context "and '/' as path" do

          it 'should have the right content' # do
            # FIX ME!
            # visit bla
            # response.should render_template(controller: 'whatever', action: 'whatever')
          # end
        end
      end
    end

    context 'for signed in users' do

      context "who haven't completed their profile" do

        it "should redirect to 'edit'" do
          @user.profile.destroy
          get :show, id: @user
          response.should redirect_to edit_user_path(@user)
          flash[:error].should == I18n.t('flash.error.only.signed_up')
        end
      end

      context 'who have completed their profile' do

        before :each do
          login_as(@user, scope: :user)
          visit user_path(@user)
        end

        it { response.should be_success }

        it 'should have a the right user profile' do
          find("div#user-#{@user.id}").should have_content @user.fullname
        end

        it 'should have an edit button with a primary style' do
          find('a.btn.btn-primary').should have_content I18n.t('users.show.edit')
        end

        it 'should have a send button' do
          find('a.btn.btn-default').should have_content I18n.t('users.show.send')
        end

        it 'should have a profile email modal' do
          find('div#profile-email-modal').should have_content I18n.t('profile_emails.new.title')
        end

        context 'visiting another user page' do

          before :each do
            sign_out @user
            sign_in  @user2
            get :show, id: @user
          end

          it 'should have kissmetrics event' do
            response.body.should have_content "_kmq.push(['record', 'Viewed profile (other user)'])"
          end

          it 'should have mixpanel event' do
            response.body.should have_content "mixpanel.track('Viewed profile (other user)')"
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
        response.body.should redirect_to root_path
        flash[:error].should == I18n.t('flash.error.only.signed_in')
      end
    end

    context 'for incorrect users' do

      it 'should redirect to the profile of the root path' do
        sign_out @user
        sign_in @user2
        get :edit, id: @user
        response.body.should redirect_to root_path
        flash[:error].should == I18n.t('flash.error.other_user.profile')
      end
    end

    context 'for correct users' do

      before :each do
        login_as(@user, scope: :user)
      end

      context "who haven't completed their profile" do

        before :each do
          @user.profile.destroy
        end

        context "after signing up with anything else than linkedin" do

          before :each do
            visit edit_user_path(@user)
          end

          it { response.should be_success }

          it 'should have the right edit form' do
            find("form.edit_user#edit_user_#{@user.id}")
          end

          it 'should have a linkedin button' do
            find('#buttons label').should have_content I18n.t('users.edit.import_from')
            all('a.btn.btn-large').first.should have_content I18n.t('users.edit.linkedin')
          end

          it 'should have an save button with a primary style' do
            find('a.btn.btn-large.btn-primary').should have_content I18n.t('users.edit.save')
          end
        end

        context "after signing up with linkedin" do

          it 'should not have a linkedin button' # do
          # FIX ME!
          # end
        end
      end

      context 'who have completed their profile' do

        before :each do
          visit edit_user_path(@user)
        end

        it { response.should be_success }

        it 'should have the right edit form' do
          find("form.edit_user#edit_user_#{@user.id}")
        end

        it 'should have an save button with a primary style' do
          find('a.btn.btn-large.btn-primary').should have_content I18n.t('users.edit.save')
        end

        it 'should have a cancel button' do
          all('a.btn.btn-large').last.should have_content I18n.t('cancel')
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

        it "should redirect to the 'show' page with a profile created message" do
          put :update, user: @attr, id: @user
          response.should redirect_to @user
          flash[:success].should == I18n.t('flash.success.profile.created')
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
          @user.profile.text.should == updated_user.profile.text
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