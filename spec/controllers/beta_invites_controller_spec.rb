require 'spec_helper'

describe BetaInvitesController do

  render_views

  before :each do
    @user   = FactoryGirl.create :user
    @invite = FactoryGirl.create :beta_invite, user: nil
    @attr   = {email: 'user@example.com'}
  end

  describe "GET 'new'" do

    it { get :new ; be_success }

    it 'should redirect signed_in users' do
      sign_in @user
      get :new
      response.should redirect_to(root_path)
    end

    it 'should have an email field' do
      get :new
      response.body.should have_selector 'input#beta_invite_email'
    end
  end

  describe "POST 'create'" do

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

    # it 'should send an email with the invitation code' do
    #   post :create, beta_invite: @attr
    # end

    it "should redirect to the 'edit'" do
      post :create, beta_invite: @attr
      response.should redirect_to edit_beta_invite_path(BetaInvite.last)
    end
  end

  describe "GET 'edit'" do

    it { get :edit, id: @invite ; be_success }

    it 'should redirect signed_in users' do
      sign_in @user
      get :edit, id: @invite
      response.should redirect_to(root_path)
    end

    it 'should have a code field' do
      get :edit, id: @invite
      response.body.should have_selector 'input#code'
    end
  end

  describe "PUT 'update'" do

    context 'nil or incorrect invitation id' do

      it 'should redirect to root_path' do
        put :update
        response.should redirect_to(root_path)
      end

      it 'should redirect to root_path' do
        put :update, id: 100
        response.should redirect_to(root_path)
      end
    end

    context 'empty or incorrect invitation code' do

      it "should redirect to 'edit'" do
        put :update, id: @invite, code: ''
        response.should redirect_to edit_beta_invite_path(@invite)
      end

      it "should redirect to 'edit'" do
        put :update, id: @invite, code: 'pouet'
        response.should redirect_to edit_beta_invite_path(@invite)
      end
    end

    context 'invitation code has already been used' do

      it "should redirect to 'new'" do
        @invite.update_attributes user_id: @user
        put :update, id: @invite, code: @invite.code
        response.should redirect_to(new_beta_invite_path)
      end
    end

    context 'invitation code has not been used' do

      it 'should redirect to sign_up' do
        put :update, id: @invite, code: @invite.code
        response.should redirect_to(new_user_registration_path(invite: @invite.id))
      end
    end
  end
end