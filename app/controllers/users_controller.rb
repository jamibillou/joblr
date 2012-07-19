class UsersController < ApplicationController

  def show
    redirect_to edit_user_path(current_user) if current_user.profiles.empty?
  end

  def edit
  	@user = User.find params[:id]
  	@user.profiles.build
  end

  def update
    @user = User.find params[:id]
    unless @user.update_attributes params[:user]
      flash[:error] = 'Houston we have a problem!'
    else
      redirect_to @user, success: 'You have a profile man!'
    end
  end
end
