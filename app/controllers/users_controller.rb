class UsersController < ApplicationController
  include ApplicationHelper

  before_filter :find_user

  def show
    @user = subdomain_user(request) if has_subdomain?(request)
  end

  def edit
    @user.profiles.build if @user.profiles.empty?
  end

  def update
    unless @user.update_attributes params[:user]
      redirect_to edit_user_path(@user), flash: { error: error_messages(@user) }
    else
      remove_file! @user.profiles.first if remove_file?(params)
      redirect_to @user, flash: { success: t('flash.success.profile_updated') }
    end
  end

  private

    def find_user
      @user = params[:id] ? User.find(params[:id]) : current_user unless has_subdomain?(request)
    end

    def remove_file?(params)
      params[:user][:profiles_attributes]['0'][:remove_file].to_i == 1
    end

    def remove_file!(profile)
      profile.remove_file!
      profile.update_attributes file: nil
    end
end
