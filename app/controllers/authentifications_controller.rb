class AuthentificationsController < ApplicationController

  def destroy
  	@authentification = current_user.authentifications.find(params[:id])
  	@authentification.destroy

  	redirect_to edit_user_registration_path
  end
end
