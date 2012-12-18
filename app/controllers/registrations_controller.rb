class RegistrationsController < Devise::RegistrationsController

  before_filter :redirect_uninvited,            only: :new
  after_filter  :associate_invite,              only: :create
  before_filter :profile_completed, :load_user, only: :edit
  before_filter :ignore_blank_email,            only: :update

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

    def associate_invite
      unless session[:invite_email].nil?
        invite_email = resource.invite_email = InviteEmail.find session[:invite_email][:id]
        invite_email.update_attributes used: true
        session[:invite_email] = nil
      end
    end
end