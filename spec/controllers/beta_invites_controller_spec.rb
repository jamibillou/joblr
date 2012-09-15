require 'spec_helper'

describe BetaInvitesController do

  render_views

  before :each do
    @user        = FactoryGirl.create :user
    @beta_invite = FactoryGirl.create :beta_invite, user: nil
    @attr        = {email: 'user@example.com'}
  end

  describe "GET 'new'" do

    it { get :new ; be_success }

    context 'for signed in users' do
      it 'should redirect to root_path' do
        sign_in @user
        get :new
        response.should redirect_to(root_path)
        flash[:error].should == I18n.t('flash.error.only.public')
      end
    end

    it 'should have an email field' do
      get :new
      response.body.should have_selector 'input#beta_invite_email'
    end
  end

  describe "POST 'create'" do

    context 'the user provided a valid email address' do
      it 'should create a new beta_invite' do
        lambda do
          post :create, beta_invite: @attr
        end.should change(BetaInvite, :count).by 1
      end

      it 'should not create a new user' do
        lambda do
          post :create, beta_invite: @attr
        end.should_not change(User, :count).by 1
      end

      it "should redirect to 'thank_you'" do
        post :create, beta_invite: @attr
        response.should redirect_to beta_invite_thank_you_path(BetaInvite.last)
      end
    end

    context "the user didn't provide an email address" do
      it 'should not create a new beta_invite' do
        lambda do
          post :create, beta_invite: {email: ''}
        end.should_not change(BetaInvite, :count).by 1
      end

      it 'should not create a new user' do
        lambda do
          post :create, beta_invite: {email: ''}
        end.should_not change(User, :count).by 1
      end

      it "should render 'new'" do
        post :create, beta_invite: {email: ''}
        response.should render_template 'new'
        flash[:error].should == "#{I18n.t('activerecord.attributes.beta_invite.email')} #{I18n.t('activerecord.errors.messages.blank')}."
      end
    end

    context "the user provided a registered email address" do
      before :each do
        beta_invite = BetaInvite.create @attr
      end

      it 'should not create a new beta_invite' do
        lambda do
          post :create, beta_invite: {email: 'user@example.com'}
        end.should_not change(BetaInvite, :count).by 1
      end

      it 'should not create a new user' do
        lambda do
          post :create, beta_invite: {email: 'user@example.com'}
        end.should_not change(User, :count).by 1
      end

      it "should render 'new'" do
        post :create, beta_invite: {email: 'user@example.com'}
        response.should render_template 'new'
        flash[:error].should == "#{I18n.t('activerecord.attributes.beta_invite.email')} #{I18n.t('activerecord.errors.messages.taken')}."
      end
    end
  end

  describe "GET 'edit'" do

    it { get :edit, id: @beta_invite ; be_success }

    context 'for signed_in users' do
      it 'should redirect to root_path' do
        sign_in @user
        get :edit, id: @beta_invite
        response.should redirect_to(root_path)
        flash[:error].should == I18n.t('flash.error.only.public')
      end
    end

    it 'should have a code field' do
      get :edit, id: @beta_invite
      response.body.should have_selector 'input#beta_invite_code'
    end
  end

  describe "PUT 'update'" do

    context 'with empty or incorrect invitation code' do

      it "should redirect to 'edit'" do
        put :update, id: @beta_invite, beta_invite: {code: ''}
        response.should redirect_to edit_beta_invite_path(@beta_invite)
        flash[:error].should == I18n.t('flash.error.beta_invite.code_inexistant')
      end

      it "should redirect to 'edit'" do
        put :update, id: @beta_invite, beta_invite: {code: 'pouet'}
        response.should redirect_to edit_beta_invite_path(@beta_invite)
        flash[:error].should == I18n.t('flash.error.beta_invite.code_inexistant')
      end
    end

    context 'when invitation code has already been used' do
      it "should redirect to 'new'" do
        @beta_invite.user = @user ; @beta_invite.save!
        put :update, id: @beta_invite, beta_invite: {code: @beta_invite.code}
        response.should redirect_to(new_beta_invite_path)
        flash[:error].should == I18n.t('flash.error.beta_invite.used')
      end
    end

    it 'should store the invitation into a session' do
      put :update, id: @beta_invite, beta_invite: {code: @beta_invite.code}
      session[:beta_invite].should == @beta_invite
    end

    it 'should redirect to sign_up' do
      put :update, id: @beta_invite, beta_invite: {code: @beta_invite.code}
      response.should redirect_to(new_user_registration_path)
      flash[:success].should == I18n.t('flash.success.beta_invite.ok')
    end
  end
end