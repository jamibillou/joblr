class RegistrationsController < Devise::RegistrationsController

  def edit
    @user = current_user
  end

  def update
    @user = User.find(current_user.id)
    if @user.update_attributes(params[:user])
      sign_in @user, :bypass => true
      redirect_to @user, flash: { success: t('flash.success.profile_updated') }
    else
      render :edit
    end
  end
end