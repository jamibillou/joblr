class UsersController < ApplicationController

  include ApplicationHelper

  def show
    @user = params[:id] ? User.find(params[:id]) : current_user
    redirect_to edit_user_path(@user) if @user.profiles.empty?
  end

  def edit
  	@user = User.find params[:id]
    @user.profiles.build if @user.profiles.empty?
  end

  def update
    @user = User.find params[:id]
    unless @user.update_attributes params[:user]
      redirect_to edit_user_path(@user), flash: { error: error_messages(@user) }
    else
      redirect_to @user, flash: { success: t('flash.success.profile_updated') }
    end
  end
end
