class RegistrationsController < Devise::RegistrationsController

  before_filter :check_beta_invite,  only: :new
  before_filter :profile_completed,  only: :edit
  before_filter :ignore_blank_email, only: :update

  def edit
    @user = current_user
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

    def check_beta_invite
      redirect_to new_beta_invite_path, flash: {error: t('flash.error.beta_invite.required')} unless session[:beta_invite]
    end

    def ignore_blank_email
      params[:user][:email] = nil if params[:user][:email].blank?
    end
end