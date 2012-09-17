require 'spec_helper'

describe AuthentificationsController do

  render_views

  before :each do
    @user      = FactoryGirl.create :user
    @user2     = FactoryGirl.create :user, fullname: FactoryGirl.generate(:fullname), username: FactoryGirl.generate(:username), email: FactoryGirl.generate(:email)
    @profile   = FactoryGirl.create :profile,          user: @user
    @profile2  = FactoryGirl.create :profile,          user: @user2
    @auth      = FactoryGirl.create :authentification, user: @user
    @auth2     = FactoryGirl.create :authentification, user: @user2, uid: 'generated_u'

    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe "POST 'create'" do

    context 'for signed in users' do

      before :each do
        login_as(@user, scope: :user)
      end

      context 'whose authentification is found' do

        context 'and is theirs' do

          before :each do
            request.env['omniauth.auth'] = OmniAuth.config.add_mock(:twitter, {:uid => @auth.uid})
            visit edit_user_path(@user)
            visit user_omniauth_authorize_path('twitter')
          end

          it 'should redirect to previous location' do
            current_path.should == edit_user_path(@user)
          end

          it 'have an error alert message' do
            # find('div.alert.alert-error span').should have_content I18n.t('flash.error.provider.already_linked', provider: 'twitter')
            find('div.alert.alert-error span').should have_content "We could not add your Twitter account because it's already linked to your profile."
          end
        end

        context 'and is not theirs' do

          before :each do
            request.env['omniauth.auth'] = OmniAuth.config.add_mock(:twitter, {:uid => @auth2.uid})
            visit edit_user_path(@user)
            visit user_omniauth_authorize_path('twitter')
          end

          it 'should redirect to previous location' do
            current_path.should == edit_user_path(@user)
          end

          it 'have an error alert message' do
            # find('div.alert.alert-error span').should have_content I18n.t('flash.error.provider.other_user', provider: 'twitter')
            find('div.alert.alert-error span').should have_content "We could not add your Twitter account because it's already linked to another user's profile."
          end
        end
      end

      context "whose authentification isn't found" do

        it 'should create a new authentification object' do
          lambda do
            request.env['omniauth.auth'] = OmniAuth.config.add_mock(:twitter, {:uid => '123456'})
            visit edit_user_path(@user)
            visit user_omniauth_authorize_path('twitter')
          end.should change(Authentification, :count).by(1)
        end

        it 'should redirect to previous location' do
          request.env['omniauth.auth'] = OmniAuth.config.add_mock(:twitter, {:uid => '123456'})
          visit edit_user_path(@user)
          visit user_omniauth_authorize_path('twitter')
          current_path.should == edit_user_path(@user)
        end

        it 'have a success alert message' do
          request.env['omniauth.auth'] = OmniAuth.config.add_mock(:twitter, {:uid => '123456'})
          visit edit_user_path(@user)
          visit user_omniauth_authorize_path('twitter')
          # find('div.alert.alert-success span').should have_content I18n.t('flash.success.provider.added', provider: 'twitter')
          find('div.alert.alert-success span').should have_content "Your Twitter account is now linked, you can sign in with it next time."
        end
      end
    end

    context 'for public vistors' do

      context 'whose authentification is found' do

        context 'and was trying to sign in' do

          before :each do
            request.env['omniauth.auth'] = OmniAuth.config.add_mock(:twitter, {:uid => @auth.uid})
            visit new_user_session_path
            visit user_omniauth_authorize_path('twitter')
          end

          it 'should sign the user in' do
            find('ul.nav li.dropdown ul.dropdown-menu li:first-child').should have_content I18n.t('devise.registrations.account_settings')
            find('ul.nav li.dropdown ul.dropdown-menu li:last-child').should have_content I18n.t('devise.sessions.logout')
          end

          it 'should redirect to root path' do
            current_path.should == root_path
          end

          it 'have a success alert message' do
            # find('div.alert.alert-success span').should have_content I18n.t('flash.success.provider.signed_in', provider: 'twitter')
            find('div.alert.alert-success span').should have_content "You are now signed in with your Twitter account."
          end
        end

        context 'and was trying to sign up' do

          before :each do
            request.env['omniauth.auth'] = OmniAuth.config.add_mock(:twitter, {:uid => @auth.uid})
            @beta_invite = FactoryGirl.create :beta_invite, user: nil
            visit edit_beta_invite_path(@beta_invite)
            find('#beta_invite_code').set(@beta_invite.code)
            click_button I18n.t('beta_invites.edit.button')
            visit user_omniauth_authorize_path('twitter')
          end

          it 'should redirect to previous location' do
            current_path.should == new_user_registration_path
          end

          it 'have an error alert message' do
            # find('div.alert.alert-error span').should have_content I18n.t('flash.error.provider.other_user_signed_up', provider: 'twitter')
            find('div.alert.alert-error span').should have_content "There already is a user matching this Twitter account, did you mean to sign in?"
          end
        end
      end

      context "whose authentification isn't found" do

        context 'and was trying to sign in' do

          before :each do
            request.env['omniauth.auth'] = OmniAuth.config.add_mock(:twitter, {:uid => '987654'})
            visit new_user_session_path
            visit user_omniauth_authorize_path('twitter')
          end

          it 'should redirect to previous location' do
            current_path.should == new_user_session_path
          end

          it 'have an error alert message' do
            # find('div.alert.alert-error span').should have_content I18n.t('flash.error.provider.no_user', provider: 'twitter')
            find('div.alert.alert-error span').should have_content "There is no user matching this Twitter profile. Make sure you are using your own account or that you did not sign up with another service."
          end
        end

        context 'and was trying to sign up' do

          before :each do
            @beta_invite = FactoryGirl.create :beta_invite, user: nil
            visit edit_beta_invite_path(@beta_invite)
            find('#beta_invite_code').set(@beta_invite.code)
            click_button I18n.t('beta_invites.edit.button')
          end

          it 'should create a new user object' do
            lambda do
              request.env['omniauth.auth'] = OmniAuth.config.add_mock(:twitter, {:uid => '987654'})
              visit user_omniauth_authorize_path('twitter')
            end.should change(User, :count).by(1)
          end

          it 'should create a new authentification object' do
            lambda do
              request.env['omniauth.auth'] = OmniAuth.config.add_mock(:twitter, {:uid => '987654'})
              visit user_omniauth_authorize_path('twitter')
            end.should change(Authentification, :count).by(1)
          end

          it 'should sign the user in' do
            request.env['omniauth.auth'] = OmniAuth.config.add_mock(:twitter, {:uid => '987654'})
            visit user_omniauth_authorize_path('twitter')
            find('ul.nav li.dropdown ul.dropdown-menu li:first-child').should have_content I18n.t('devise.registrations.account_settings')
            find('ul.nav li.dropdown ul.dropdown-menu li:last-child').should have_content I18n.t('devise.sessions.logout')
          end

          it 'should redirect to previous location' do
            request.env['omniauth.auth'] = OmniAuth.config.add_mock(:twitter, {:uid => '987654'})
            visit user_omniauth_authorize_path('twitter')
            current_path.should == root_path
          end

          it 'have a success alert message' do
            request.env['omniauth.auth'] = OmniAuth.config.add_mock(:twitter, {:uid => '987654'})
            visit user_omniauth_authorize_path('twitter')
            # find('div.alert.alert-success span').should have_content I18n.t('flash.success.provider.signed_in', provider: 'twitter')
            find('div.alert.alert-success span').should have_content "You have successfully signed up with Twitter, you can now fill in your profile."
          end
        end
      end
    end
  end

  describe 'failure' do

    before :each do
      login_as(@user, scope: :user)
      request.env['omniauth.auth'] = (OmniAuth.config.mock_auth[:facebook] = :invalid_credentials)
      visit edit_user_path(@user)
      visit user_omniauth_authorize_path('facebook')
    end

    it 'should redirect to previous location' do
      # Omniauth bug, request.env['omniauth.origin'] is not set by mock_call!
      current_path.should == root_path
    end

    it 'have an error alert message' do
      find('div.alert.alert-error span').should have_content I18n.t('flash.error.something_wrong.auth')
    end
  end

  describe "DELETE 'destroy" do

    before :each do
      login_as(@user, scope: :user)
      visit edit_user_path(@user)
      request.env['HTTP_REFERER'] = edit_user_path(@user)
      delete :destroy, id: @auth
    end

    it 'should redirect to previous location' do
      response.should redirect_to edit_user_path(@user)
    end

    it 'have a success alert message' do
      flash[:success].should == I18n.t('flash.success.provider.removed', provider: 'Twitter')
    end
  end
end