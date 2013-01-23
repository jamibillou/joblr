class RegistrationsController < Devise::RegistrationsController

  after_filter  :use_invite,                    only: :create
  before_filter :profile_completed, :load_user, only: :edit
  before_filter :ignore_blank_email,            only: :update

  def new
    @user = session[:auth_hash] ? User.new(session[:auth_hash][:user]) : User.new
  end

  def create
    @user = User.new params[:user].merge(social: (session[:auth_hash] ? true : false))
    if @user.save
      @user.authentications.create(session[:auth_hash][:authentication]) if session[:auth_hash]
      session[:auth_hash] = nil
      sign_in @user, bypass: true
      redirect_to root_path, flash: {success: t('flash.success.welcome')}
    else
      flash[:error] = error_messages @user
      render :new
    end
  end

  def update
    @user = User.find current_user.id
    if @user.update_attributes(params[:user])
      sign_in @user, bypass: true
      redirect_to @user, flash: {success: t('flash.success.profile.updated')}
    else
      render :edit
    end
  end

  private

    def redirect_uninvited
      redirect_to new_invite_email_path, flash: {error: t('flash.error.invite_email.required')} unless session[:invite_email]
    end

    def ignore_blank_email
      params[:user][:email] = nil if params[:user][:email].blank?
    end

    def use_invite
      unless session[:invite_email].nil?
        InviteEmail.find(session[:invite_email][:id]).use_invite(resource)
        session[:invite_email] = nil
      end
    end
end