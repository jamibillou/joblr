class UsersController < ApplicationController
  include UsersHelper

  before_filter :find_user,           unless: :has_subdomain
  before_filter :find_subdomain_user, if: :has_subdomain

  def show
    redirect_to edit_user_path(@user) unless signed_up?(@user)
  end

  def edit
    unless signed_up?(@user)
      @user.profiles.build
      @linkedin = @user.linkedin_profile if @user.has_auth?('linkedin')
    end
  end

  def update
    unless @user.update_attributes params[:user]
      redirect_to edit_user_path(@user), flash: { error: error_messages(@user) }
    else
      remove_files!
      redirect_to @user, flash: { success: t('flash.success.profile_updated') }
    end
  end

  def share_profile
    UserMailer.share_profile(params[:email]).deliver
    redirect_to @user, flash: { success: t('flash.success.profile_shared') }
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

    # Kludge until https://github.com/jnicklas/carrierwave/pull/712 is included the gem
    # Still doesn't work though: the file is deleted as excpected but the column isn't emptied.
    # This isn't needed anyway, :remove_#{attr} check_box should do this automatically.
    # Weirdly it only works for the image, with the above bug of course...
    def remove_files!
      remove_file! @user.profile
      remove_image! @user
    end

    def remove_file!(profile)
      if params[:user][:profiles_attributes]['0'][:remove_file] == '1'
        profile.remove_file = true
        profile.save
      end
    end

    def remove_image!(user)
      if params[:user][:remove_image] == '1'
        user.remove_image = true
        user.save
      end
    end
end
