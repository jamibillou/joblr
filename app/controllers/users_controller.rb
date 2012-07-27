class UsersController < ApplicationController
  include UsersHelper

  before_filter :find_user,           unless: :has_subdomain
  before_filter :find_subdomain_user, if: :has_subdomain

  def show
  end

  def edit
    unless signed_up?(@user)
      @user.profiles.build
      @title = 'Complete your profile!'
      @save = 'Create your profile!'
    else
      @title = 'Edit your profile'
      @save = 'Save your profile'
    end
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
      @user = params[:id] ? User.find(params[:id]) : current_user
    end

    def find_subdomain_user
      @user = User.find_by_subdomain! request.subdomain
    rescue ActiveRecord::RecordNotFound
      redirect_to root_url(subdomain: false), flash: { error: t('flash.error.subdomain.profile_doesnt_exist') }
    end

    def remove_file?(params)
      params[:user][:profiles_attributes]['0'][:remove_file].to_i == 1
    end

    def remove_file!(profile)
      profile.remove_file!
      profile.update_attributes file: nil
    end
end
