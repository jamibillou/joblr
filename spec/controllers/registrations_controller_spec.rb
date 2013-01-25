require 'spec_helper'

describe RegistrationsController do

  render_views

  before :each do
    @user         = FactoryGirl.create :user
    @attr         = { fullname: 'New User', username: 'newuser', email: 'newuser@example.com', password: 'pouetpouet', password_confirmation: 'pouetpouet' }
    @full_attr    = { fullname: 'Tony Leung', city: 'Hong Kong', country: 'China', profiles_attributes: { '0' => { experience: 10, education: 'none' } } }
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe "GET 'new'" do

    context 'for signed in users' do

      before :each do
        sign_in @user
      end

      it 'should redirect to root path' do
        get :new
        response.should redirect_to(root_path)
        flash[:alert].should == I18n.t('devise.failure.already_authenticated')
      end
    end

    context 'for public users' do

      it { get :new ; response.should be_success }

      context 'who used social_signup' do

        it 'should have the right titles' do
          session[:auth_hash] = {user: @attr}
          get :new
          response.body.should have_selector 'h1', text: I18n.t('devise.registrations.new.account_info')
          response.body.should have_content I18n.t('devise.registrations.new.so_we_know')
        end
      end

      context 'who are signing up manually' do

        it 'should have the right titles' do
          get :new
          response.body.should have_selector 'h1', text: I18n.t('devise.registrations.new.title')
          response.body.should have_content I18n.t('devise.registrations.new.fill_account_info')
        end
      end

      it 'should have a signup form' do
        get :new
        response.body.should have_selector '#new_user'
      end
    end
  end

  describe "PUT 'update'" do

    before :each do
      sign_in @user
    end

    context "for users who didn't provide a fullname" do
      it 'should redirect to user' do
        put :update, user: @full_attr.merge(fullname: ''), id: @user.id
        response.should render_template(:edit)
        flash[:error].should == errors('user.fullname', 'blank')
      end
    end

    context "for users who didn't provide an experience" do
      it 'should redirect to user' do
        put :update, user: @full_attr.merge(profiles_attributes: {'0' => {experience: '', education: 'none'}}), id: @user.id
        response.should render_template(:edit)
        flash[:error].should == errors('user/profiles.experience', 'not_a_number')
      end
    end

    context "for users who didn't provide an education" do
      it 'should redirect to user' do
        put :update, user: @full_attr.merge(profiles_attributes: {'0' => {experience: 10, education: ''}}), id: @user.id
        response.should render_template(:edit)
        flash[:error].should == errors('user/profiles.education', 'blank')
      end
    end

    context 'for users who completed all required fields' do
      it 'should redirect to user' do
        put :update, user: @full_attr, id: @user.id
        response.should redirect_to @user
        flash[:success].should == I18n.t('flash.success.profile.updated')
      end
    end
  end

  describe "POST 'create'" do

    context 'for users who signed up manually' do

      context "and didn't provide any fullname" do
        it 'should not create a new user' do
          lambda do
            post :create, user: @attr.merge(fullname: '')
          end.should_not change(User, :count).by 1
        end
      end

      context "and didn't provide any username" do
        it 'should not create a new user' do
          lambda do
            post :create, user: @attr.merge(username: '')
          end.should_not change(User, :count).by 1
        end
      end

      context "and didn't provide any password" do
        it 'should not create a new user' do
          lambda do
            post :create, user: @attr.merge(password: '')
          end.should_not change(User, :count).by 1
        end
      end

      context "and didn't provide any password confirmation" do
        it 'should not create a new user' do
          lambda do
            post :create, user: @attr.merge(password_confirmation: '')
          end.should_not change(User, :count).by 1
        end
      end

      context 'and filled in all required fields' do

        it 'should create a new user' do
          lambda do
            post :create, user: @attr
          end.should change(User, :count).by 1
        end
      end

      it 'should redirect to root path' do
        post :create, user: @attr
        response.should redirect_to(root_path)
        flash[:success].should == I18n.t('flash.success.welcome')
      end

      context 'after using social signup' do

        before :each do
          session[:auth_hash] = {user: {username: 'username', fullname: 'Full name', email: '', remote_image_url: ''}, authentication: {provider: 'twitter', uid: '123456', url: 'http://twitter.com/username', utoken: '987654', usecret: '456789'}}
        end

        it 'should create a new social user' do
          lambda do
            post :create, user: @attr
            User.find_by_email(@attr[:email]).should be_social
          end.should change(User, :count).by 1
        end

        it 'should create a new authentication' do
          lambda do
            post :create, user: @attr
          end.should change(Authentication, :count).by 1
        end

        it 'should destroy the session' do
          post :create, user: @attr
          session[:auth_hash].should be_nil
        end
      end
    end
  end
end
