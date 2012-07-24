class AuthentificationsController < ApplicationController

  def destroy
  	@authentification = current_user.authentifications.find(params[:id])
  	flash[:notice] = "You removed your #{@authentification.provider.titleize} account to your profile."
  	@authentification.destroy
  	redirect_to edit_user_path(current_user)
  end
end
