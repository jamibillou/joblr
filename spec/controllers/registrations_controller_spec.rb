require 'spec_helper'

describe RegistrationsController do

  render_views

  before :each do
    @user         = FactoryGirl.create :user
    @invite_email = FactoryGirl.create :invite_email, user: nil
    @attr         = { fullname: 'New User', username: 'newuser', password: 'pouetpouet', password_confirmation: 'pouetpouet' }
    @full_attr    = { fullname: 'Tony Leung', city: 'Hong Kong', country: 'China', profiles_attributes: { '0' => { headline: 'fulltime', experience: 10, education: 'none', text: 'A good and highly motivated guy.' } } }
    request.env['devise.mapping'] = Devise.mappings[:user]
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

    context "for users who didn't provide a summary" do
      it 'should redirect to user' do
        put :update, user: @full_attr.merge(profiles_attributes: {'0' => {headline: 'fulltime', experience: 10, education: 'none', text: ''}}), id: @user.id
        response.should render_template(:edit)
        flash[:error].should == errors('user/profiles.text', 'blank')
      end
    end

    context "for users who didn't provide a headline" do
      it 'should redirect to user' do
        put :update, user: @full_attr.merge(profiles_attributes: {'0' => {headline: '', experience: 10, education: 'none', text: 'A good and highly motivated guy.'}}), id: @user.id
        response.should render_template(:edit)
        flash[:error].should == errors('user/profiles.headline', 'headline_format')
      end
    end

    context "for users who didn't provide an experience" do
      it 'should redirect to user' do
        put :update, user: @full_attr.merge(profiles_attributes: {'0' => {headline: 'fulltime', experience: '', education: 'none', text: 'A good and highly motivated guy.'}}), id: @user.id
        response.should render_template(:edit)
        flash[:error].should == errors('user/profiles.experience', 'not_a_number')
      end
    end

    context "for users who didn't provide an education" do
      it 'should redirect to user' do
        put :update, user: @full_attr.merge(profiles_attributes: {'0' => {headline: 'fulltime', experience: 10, education: '', text: 'A good and highly motivated guy.'}}), id: @user.id
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

    context 'for users who signed up with an invite_email' do

      before(:each) { session[:invite_email] = @invite_email }

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

        it 'should associate the user and the invite_email' do
          post :create, user: @attr
          User.last.invite_email.id.should == @invite_email.id
          User.last.invite_email.should == @invite_email
        end

        it "should not update the user's email if he already had one" do
          post :create, user: @attr.merge(email: 'one.email@example.com')
          User.last.email.should_not == @invite_email.recipient_email
        end

        it "should update the user's email if he didn't have one" do
          post :create, user: @attr
          User.last.email.should == @invite_email.recipient_email
        end

        it 'should destroy the session' do
          post :create, user: @attr
          session[:invite_email].should be_nil
        end
      end
    end
  end
end
