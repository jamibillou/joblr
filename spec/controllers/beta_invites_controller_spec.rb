require 'spec_helper'

describe BetaInvitesController do

  render_views

  before :each do
    @user        = FactoryGirl.create :user
    @beta_invite = FactoryGirl.create :beta_invite, user: nil
    @attr        = {email: 'user@example.com'}
  end

  describe "GET 'new'" do

    context 'for signed in users' do

      it 'should redirect to root_path' do
        sign_in @user
        get :new
        response.should redirect_to(root_path)
        flash[:error].should == I18n.t('flash.error.only.public')
      end
    end

    context 'for public users' do

      it { get :new ; be_success }

      it 'should have an email field' do
        get :new
        response.body.should have_selector 'input#beta_invite_email'
      end
    end
  end

  describe "POST 'create'" do

    context 'for signed in users' do

      it 'should redirect to root_path' do
        sign_in @user
        post :create, beta_invite: @attr
        response.should redirect_to(root_path)
        flash[:error].should == I18n.t('flash.error.only.public')
      end
    end

    context 'for public users' do

      context 'who provided a valid email address' do

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

        it 'should notify the team' do
          email = mock Mail::Message
          BetaInviteMailer.should_receive(:notify_team).with(kind_of(BetaInvite)).and_return(email)
          email.should_receive(:deliver)
          post :create, beta_invite: @attr
        end

        it "should redirect to thank you page" do
          post :create, beta_invite: @attr
          response.should redirect_to beta_invite_thank_you_path(BetaInvite.last)
        end
      end

      context "who didn't provide any email address" do

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

        it 'should not notify the team' do
          email = mock Mail::Message
          BetaInviteMailer.should_not_receive(:notify_team).with(kind_of(BetaInvite)).and_return(email)
          email.should_not_receive(:deliver)
          post :create, beta_invite: {email: ''}
        end

        it "should render 'new'" do
          post :create, beta_invite: {email: ''}
          response.should render_template 'new'
          flash[:error].should == "#{I18n.t('activerecord.attributes.beta_invite.email')} #{I18n.t('activerecord.errors.messages.blank')}."
        end
      end

      context "who provided an email address that has already requested a beta invite" do

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

        it 'should not notify the team' do
          email = mock Mail::Message
          BetaInviteMailer.should_not_receive(:notify_team).with(kind_of(BetaInvite)).and_return(email)
          email.should_not_receive(:deliver)
          post :create, beta_invite: {email: 'user@example.com'}
        end

        it "should render 'new'" do
          post :create, beta_invite: {email: 'user@example.com'}
          response.should render_template 'new'
          flash[:error].should == "#{I18n.t('activerecord.attributes.beta_invite.email')} #{I18n.t('activerecord.errors.messages.taken')}."
        end
      end
    end
  end

  describe "GET 'thank_you'" do
    it { get :thank_you, beta_invite_id: @beta_invite ; be_success }

    it 'should have kissmetrics event' do
      get :thank_you, beta_invite_id: @beta_invite
      response.body.should have_content "_kmq.push(['record', 'Requested a beta invite'])"
    end
  end

  describe "GET 'send_code'" do

    context 'for public users' do

      it 'should not send the invitation code' do
        email = mock Mail::Message
        BetaInviteMailer.should_not_receive(:send_code).with(kind_of(BetaInvite)).and_return(email)
        email.should_not_receive(:deliver)
        get :send_code, beta_invite_id: @beta_invite
      end

      it 'should not update the beta invite' do
        get :send_code, beta_invite_id: @beta_invite
        @beta_invite.reload
        @beta_invite.should_not be_sent
      end

      it 'should redirect to the root path' do
        get :send_code, beta_invite_id: @beta_invite
        response.should redirect_to root_path
        flash[:error].should == I18n.t('flash.error.only.admin')
      end
    end

    context 'for signed-in users' do

      before :each do
        sign_in @user
      end

      context 'who are not admin' do

        it 'should not send the invitation code' do
          email = mock Mail::Message
          BetaInviteMailer.should_not_receive(:send_code).with(kind_of(BetaInvite)).and_return(email)
          email.should_not_receive(:deliver)
          get :send_code, beta_invite_id: @beta_invite
        end

        it 'should not update the beta invite' do
          get :send_code, beta_invite_id: @beta_invite
          @beta_invite.reload
          @beta_invite.should_not be_sent
        end

        it 'should redirect to the root path' do
          get :send_code, beta_invite_id: @beta_invite
          response.should redirect_to root_path
          flash[:error].should == I18n.t('flash.error.only.admin')
        end
      end

      context 'who are admin' do

        before :each do
          @user.toggle! :admin
        end

        it 'should send the invitation code' do
          email = mock Mail::Message
          BetaInviteMailer.should_receive(:send_code).with(kind_of(BetaInvite)).and_return(email)
          email.should_receive(:deliver)
          get :send_code, beta_invite_id: @beta_invite
        end

        it 'should update the beta invite' do
          get :send_code, beta_invite_id: @beta_invite
          @beta_invite.reload
          @beta_invite.should be_sent
        end

        it 'should redirect to the admin page' do
          get :send_code, beta_invite_id: @beta_invite
          response.should redirect_to admin_path
          flash[:success].should == I18n.t('flash.success.beta_invite.email_sent')
        end
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

    context 'for public users' do

      before :each do
        get :edit, id: @beta_invite
      end

      it 'should have a code text field' do
        response.body.should have_selector 'input#beta_invite_code'
      end

      it 'should have kissmetrics event' do
        response.body.should have_content "_kmq.push(['record', 'Viewed use beta invite page'])"
      end
    end
  end

  describe "PUT 'update'" do

    context 'with empty or incorrect invitation codes' do

      it 'should not store the invitation into a session' do
        put :update, id: @beta_invite, beta_invite: {code: ''}
        session[:beta_invite].should_not == @beta_invite
      end

      it "should redirect to 'edit'" do
        put :update, id: @beta_invite, beta_invite: {code: ''}
        response.should redirect_to edit_beta_invite_path(@beta_invite)
        flash[:error].should == I18n.t('flash.error.beta_invite.code_inexistant')
      end

      it 'should not store the invitation into a session' do
        put :update, id: @beta_invite, beta_invite: {code: 'pouet'}
        session[:beta_invite].should_not == @beta_invite
      end

      it "should redirect to 'edit'" do
        put :update, id: @beta_invite, beta_invite: {code: 'pouet'}
        response.should redirect_to edit_beta_invite_path(@beta_invite)
        flash[:error].should == I18n.t('flash.error.beta_invite.code_inexistant')
      end
    end

    context 'for invitation codes that have already been used' do

      before :each do
        @beta_invite.user = @user
        @beta_invite.save!
      end

      it "should redirect to 'new'" do
        put :update, id: @beta_invite, beta_invite: {code: @beta_invite.code}
        response.should redirect_to(new_beta_invite_path)
        flash[:error].should == I18n.t('flash.error.beta_invite.used')
      end

      it 'should not store the invitation into a session' do
        put :update, id: @beta_invite, beta_invite: {code: @beta_invite.code}
        session[:beta_invite].should_not == @beta_invite
      end
    end

    context 'for invitation codes that have not been used yet' do

      it 'should store the invitation into a session' do
        put :update, id: @beta_invite, beta_invite: {code: @beta_invite.code}
        session[:beta_invite].should == @beta_invite
      end

      it 'should redirect to sign_up' do
        put :update, id: @beta_invite, beta_invite: {code: @beta_invite.code}
        response.should redirect_to(new_user_registration_path)
        flash[:success].should == I18n.t('flash.success.beta_invite.used')
      end
    end
  end

  describe "delete 'DESTROY'" do

    context 'for public users' do

      it 'should not destroy the beta_invite' do
        lambda do
          delete :destroy, id: @beta_invite
        end.should_not change(BetaInvite, :count)
      end

      it 'should redirect to the root path' do
        delete :destroy, id: @beta_invite
        response.should redirect_to root_path
        flash[:error].should == I18n.t('flash.error.only.admin')
      end
    end

    context 'for signed-in users' do

      before :each do
        sign_in @user
      end

      context 'who are not admin' do

        it 'should not destroy the beta_invite' do
          lambda do
            delete :destroy, id: @beta_invite
          end.should_not change(BetaInvite, :count)
        end

        it 'should redirect to the root path' do
          delete :destroy, id: @beta_invite
          response.should redirect_to root_path
          flash[:error].should == I18n.t('flash.error.only.admin')
        end
      end

      context 'who are admin' do

        before :each do
          @user.toggle! :admin
        end

        it 'should destroy the beta_invite' do
          lambda do
            delete :destroy, id: @beta_invite
          end.should change(BetaInvite, :count).by -1
        end

        it 'should redirect to the admin page' do
          delete :destroy, id: @beta_invite
          response.should redirect_to admin_path
          flash[:success].should == I18n.t('flash.success.beta_invite.destroyed')
        end
      end
    end
  end
end