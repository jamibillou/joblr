class UsersController < ApplicationController

  def show
    @user = params[:id] ? User.find(params[:id]) : current_user
    redirect_to edit_user_path(@user) if @user.profiles.empty?
  end

  def edit
  	@user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]
    unless @user.update_attributes params[:user]
      redirect_to edit_user_path(@user), error: 'Houston we have a problem!'
    else
      redirect_to @user, success: 'You have a profile man!'
    end
  end
end
