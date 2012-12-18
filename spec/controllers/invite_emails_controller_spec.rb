require 'spec_helper'

describe InviteEmailsController do

  render_views

  before :each do
    @user         = FactoryGirl.create :user
    @invite_email = FactoryGirl.create :invite_email, user: nil
    @attr         = {recipient_email: 'user@example.com'}
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
        response.body.should have_selector 'input#invite_email_recipient_email'
      end
    end
  end

  describe "POST 'create'" do

    context 'for signed in users' do

      it 'should redirect to root_path' do
        sign_in @user
        post :create, invite_email: @attr
        response.should redirect_to(root_path)
        flash[:error].should == I18n.t('flash.error.only.public')
      end
    end

    context 'for public users' do

      context "who didn't provide any email address" do

        it 'should not create a new invite_email' do
          lambda do
            post :create, invite_email: {recipient_email: ''}
          end.should_not change(InviteEmail, :count).by 1
        end

        it 'should not create a new user' do
          lambda do
            post :create, invite_email: {recipient_email: ''}
          end.should_not change(User, :count).by 1
        end

        it 'should not notify the team' do
          email = mock Mail::Message
          InviteEmailMailer.should_not_receive(:notify_team).with(kind_of(InviteEmail)).and_return(email)
          email.should_not_receive(:deliver)
          post :create, invite_email: {recipient_email: ''}
        end

        it "should render 'new'" do
          post :create, invite_email: {recipient_email: ''}
          response.should render_template 'new'
          flash[:error].should include I18n.t('activerecord.attributes.invite_email.recipient_email')
        end
      end

      context "who provided an email address that has already requested an invitation" do

        before :each do
          invite_email = InviteEmail.create @attr
        end

        it 'should not create a new invite_email' do
          lambda do
            post :create, invite_email: {recipient_email: 'user@example.com'}
          end.should_not change(InviteEmail, :count).by 1
        end

        it 'should not create a new user' do
          lambda do
            post :create, invite_email: {recipient_email: 'user@example.com'}
          end.should_not change(User, :count).by 1
        end

        it 'should not notify the team' do
          email = mock Mail::Message
          InviteEmailMailer.should_not_receive(:notify_team).with(kind_of(InviteEmail)).and_return(email)
          email.should_not_receive(:deliver)
          post :create, invite_email: {recipient_email: 'user@example.com'}
        end

        it "should render 'new'" do
          post :create, invite_email: {recipient_email: 'user@example.com'}
          response.should render_template 'new'
          flash[:error].should == "#{I18n.t('activerecord.attributes.invite_email.recipient_email')} #{I18n.t('activerecord.errors.messages.taken')}."
        end
      end

      context "who provided the email address of an existing user" do

        it 'should not create a new invite_email' do
          lambda do
            post :create, invite_email: {recipient_email: @user.email}
          end.should_not change(InviteEmail, :count).by 1
        end

        it 'should not create a new user' do
          lambda do
            post :create, invite_email: {recipient_email: @user.email}
          end.should_not change(User, :count).by 1
        end

        it 'should not notify the team' do
          email = mock Mail::Message
          InviteEmailMailer.should_not_receive(:notify_team).with(kind_of(InviteEmail)).and_return(email)
          email.should_not_receive(:deliver)
          post :create, invite_email: {recipient_email: @user.email}
        end

        it "should render 'new'" do
          post :create, invite_email: {recipient_email: @user.email}
          response.should redirect_to new_invite_email_path
          flash[:error].should == I18n.t('flash.error.invite_email.user_exists')
        end
      end

      context 'who provided a valid email address' do

        it 'should create a new invite_email' do
          lambda do
            post :create, invite_email: @attr
          end.should change(InviteEmail, :count).by 1
        end

        it 'should not create a new user' do
          lambda do
            post :create, invite_email: @attr
          end.should_not change(User, :count).by 1
        end

        it 'should notify the team' do
          email = mock Mail::Message
          InviteEmailMailer.should_receive(:notify_team).with(kind_of(InviteEmail)).and_return(email)
          email.should_receive(:deliver)
          post :create, invite_email: @attr
        end

        it "should redirect to thank you page" do
          post :create, invite_email: @attr
          response.should redirect_to invite_email_thank_you_path(InviteEmail.last)
        end
      end
    end
  end

  describe "GET 'thank_you'" do
    it { get :thank_you, invite_email_id: @invite_email ; be_success }

    it 'should have kissmetrics event' do
      get :thank_you, invite_email_id: @invite_email
      response.body.should have_content "_kmq.push(['record', 'Requested an invitation'])"
    end

    it 'should have mixpanel event' do
      get :thank_you, invite_email_id: @invite_email
      response.body.should have_content "mixpanel.track('Requested an invitation')"
    end
  end

  describe "GET 'send_code'" do

    context 'for public users' do

      it 'should not send the invitation code' do
        email = mock Mail::Message
        InviteEmailMailer.should_not_receive(:send_code).with(kind_of(InviteEmail)).and_return(email)
        email.should_not_receive(:deliver)
        get :send_code, invite_email_id: @invite_email
      end

      it 'should not update the invite email' do
        get :send_code, invite_email_id: @invite_email
        @invite_email.reload
        @invite_email.should_not be_sent
      end

      it 'should redirect to the root path' do
        get :send_code, invite_email_id: @invite_email
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
          InviteEmailMailer.should_not_receive(:send_code).with(kind_of(InviteEmail)).and_return(email)
          email.should_not_receive(:deliver)
          get :send_code, invite_email_id: @invite_email
        end

        it 'should not update the invite email' do
          get :send_code, invite_email_id: @invite_email
          @invite_email.reload
          @invite_email.should_not be_sent
        end

        it 'should redirect to the root path' do
          get :send_code, invite_email_id: @invite_email
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
          InviteEmailMailer.should_receive(:send_code).with(kind_of(InviteEmail)).and_return(email)
          email.should_receive(:deliver)
          get :send_code, invite_email_id: @invite_email
        end

        it 'should update the invite email' do
          get :send_code, invite_email_id: @invite_email
          @invite_email.reload
          @invite_email.should be_sent
        end

        it 'should redirect to the admin page' do
          get :send_code, invite_email_id: @invite_email
          response.should redirect_to admin_path
          flash[:success].should == I18n.t('flash.success.invite_email.email_sent')
        end
      end
    end
  end

  describe "GET 'edit'" do

    it { get :edit, id: @invite_email ; be_success }

    context 'for signed_in users' do

      it 'should redirect to root_path' do
        sign_in @user
        get :edit, id: @invite_email
        response.should redirect_to(root_path)
        flash[:error].should == I18n.t('flash.error.only.public')
      end
    end

    context 'for public users' do

      before :each do
        get :edit, id: @invite_email
      end

      it 'should have a code text field' do
        response.body.should have_selector 'input#invite_email_code'
      end

      it 'should have kissmetrics event' do
        response.body.should have_content "_kmq.push(['record', 'Viewed use invite page'])"
      end

      it 'should have mixpanel event' do
        response.body.should have_content "mixpanel.track('Viewed use invite page')"
      end
    end
  end

  describe "PUT 'update'" do

    context 'with empty or incorrect invitation codes' do

      it 'should not store the invitation into a session' do
        put :update, id: @invite_email, invite_email: {code: ''}
        session[:invite_email].should_not == @invite_email
      end

      it "should redirect to 'edit'" do
        put :update, id: @invite_email, invite_email: {code: ''}
        response.should redirect_to edit_invite_email_path(@invite_email)
        flash[:error].should == I18n.t('flash.error.invite_email.code_inexistant')
      end

      it 'should not store the invitation into a session' do
        put :update, id: @invite_email, invite_email: {code: 'pouet'}
        session[:invite_email].should_not == @invite_email
      end

      it "should redirect to 'edit'" do
        put :update, id: @invite_email, invite_email: {code: 'pouet'}
        response.should redirect_to edit_invite_email_path(@invite_email)
        flash[:error].should == I18n.t('flash.error.invite_email.code_inexistant')
      end
    end

    context 'for invitation codes that have already been used' do

      before :each do
        @invite_email.user = @user
        @invite_email.used = true
        @invite_email.save!
      end

      it "should redirect to 'new'" do
        put :update, id: @invite_email, invite_email: {code: @invite_email.code}
        response.should redirect_to(new_invite_email_path)
        flash[:error].should == I18n.t('flash.error.invite_email.used')
      end

      it 'should not store the invitation into a session' do
        put :update, id: @invite_email, invite_email: {code: @invite_email.code}
        session[:invite_email].should_not == @invite_email
      end
    end

    context 'for invitation codes that have not been used yet' do

      it 'should store the invitation into a session' do
        put :update, id: @invite_email, invite_email: {code: @invite_email.code}
        session[:invite_email].should == @invite_email
      end

      it 'should redirect to sign_up' do
        put :update, id: @invite_email, invite_email: {code: @invite_email.code}
        response.should redirect_to(new_user_registration_path)
        flash[:success].should == I18n.t('flash.success.invite_email.used')
      end
    end
  end

  describe "delete 'DESTROY'" do

    context 'for public users' do

      it 'should not destroy the invite_email' do
        lambda do
          delete :destroy, id: @invite_email
        end.should_not change(InviteEmail, :count)
      end

      it 'should redirect to the root path' do
        delete :destroy, id: @invite_email
        response.should redirect_to root_path
        flash[:error].should == I18n.t('flash.error.only.admin')
      end
    end

    context 'for signed-in users' do

      before :each do
        sign_in @user
      end

      context 'who are not admin' do

        it 'should not destroy the invite_email' do
          lambda do
            delete :destroy, id: @invite_email
          end.should_not change(InviteEmail, :count)
        end

        it 'should redirect to the root path' do
          delete :destroy, id: @invite_email
          response.should redirect_to root_path
          flash[:error].should == I18n.t('flash.error.only.admin')
        end
      end

      context 'who are admin' do

        before :each do
          @user.toggle! :admin
        end

        it 'should destroy the invite_email' do
          lambda do
            delete :destroy, id: @invite_email
          end.should change(InviteEmail, :count).by -1
        end

        it 'should redirect to the admin page' do
          delete :destroy, id: @invite_email
          response.should redirect_to admin_path
          flash[:success].should == I18n.t('flash.success.invite_email.destroyed')
        end
      end
    end
  end
end