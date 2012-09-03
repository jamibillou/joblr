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

          it "should redirect to previous location" do
            current_path.should == edit_user_path(@user)
          end

          it "should set the flash" do
            page.should have_selector 'div.alert.alert-error', content: I18n.t('flash.error.provider.already_linked', provider: 'twitter')
          end
        end

        context 'and is not theirs' do

          before :each do
            request.env['omniauth.auth'] = OmniAuth.config.add_mock(:twitter, {:uid => @auth2.uid})
            visit edit_user_path(@user)
            visit user_omniauth_authorize_path('twitter')
          end

          it "should redirect to previous location" do
            current_path.should == edit_user_path(@user)
          end

          it "should set the flash" do
            page.should have_selector 'div.alert.alert-error', content: I18n.t('flash.error.provider.other_user', provider: 'twitter')
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

        it 'should set the flash' do
          request.env['omniauth.auth'] = OmniAuth.config.add_mock(:twitter, {:uid => '123456'})
          visit edit_user_path(@user)
          visit user_omniauth_authorize_path('twitter')
          page.should have_selector 'div.alert.alert-success', content: I18n.t('flash.success.provider.added', provider: 'twitter')
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

          it 'should sign user in' # do
          # end

          it 'should redirect to root_path' do
            current_path.should == root_path
          end

          it "should set the flash" do
            page.should have_selector 'div.alert.alert-success', content: I18n.t('flash.success.provider.signed_in', provider: 'twitter')
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

          it "should set the flash" do
            page.should have_selector 'div.alert.alert-error', content: I18n.t('flash.error.provider.other_user_signed_up', provider: 'twitter')
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

          it "should set the flash" do
            page.should have_selector 'div.alert.alert-error', content: I18n.t('flash.error.provider.no_user', provider: 'twitter')
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

          it 'should sign the user in' # do
          # end

          it 'should redirect to root_path' do
            request.env['omniauth.auth'] = OmniAuth.config.add_mock(:twitter, {:uid => '987654'})
            visit user_omniauth_authorize_path('twitter')
            current_path.should == root_path
          end

          it 'should set the flash' do
            request.env['omniauth.auth'] = OmniAuth.config.add_mock(:twitter, {:uid => '987654'})
            visit user_omniauth_authorize_path('twitter')
            page.should have_selector 'div.alert.alert-success', content: I18n.t('flash.success.provider.signed_in', provider: 'twitter')
          end
        end
      end
    end
  end
end