class UsersController < ApplicationController

  def show
    redirect_to edit_user_path(current_user) if current_user.profiles.empty?
  end

  def edit
  	@user = User.find params[:id]
  	@user.profiles.build
  end
end
