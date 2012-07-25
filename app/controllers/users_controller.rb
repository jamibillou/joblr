class UsersController < ApplicationController
  include ApplicationHelper

  before_filter :retrieve_user

  def show
    @user = subdomain_user(request) if request.subdomain.present?
  rescue ActiveRecord::RecordNotFound
    redirect_to root_url(subdomain: false), flash: { error: t('flash.error.subdomain_doesnt_exist') }
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

    def retrieve_user
      @user = params[:id] ? User.find(params[:id]) : current_user
    end

    def remove_file?(params)
      params[:user][:profiles_attributes]['0'][:remove_file].to_i == 1
    end

    def remove_file!(profile)
      profile.remove_file!
      profile.update_attributes file: nil
    end

    def subdomain_user(request)
      User.find_by_subdomain! request.subdomain
    end
end
