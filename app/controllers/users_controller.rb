class UsersController < ApplicationController

  before_filter :find_user,             unless: :has_subdomain
  before_filter :find_subdomain_user,   if: :has_subdomain
  before_filter :signed_up,             only: :show
  before_filter :correct_user!,         only: [:edit, :update]
  before_filter :associate_beta_invite, only: :update

  def show
  end

  def edit
    unless signed_up?(@user)
      @user.profiles.build
      @linkedin = @user.auth('linkedin').profile if @user.has_auth?('linkedin')
    end
  end

  def update
    unless @user.update_attributes params[:user]
      redirect_to edit_user_path(@user), flash: {error: error_messages(@user)}
    else
      remove_files! # FIX ME!
      redirect_to @user, flash: {success: t('flash.success.profile_updated')}
    end
  end

  private

    def find_subdomain_user
      @user = User.find_by_subdomain! request.subdomain
    rescue ActiveRecord::RecordNotFound
      redirect_to root_url(subdomain: false), flash: {error: t('flash.error.subdomain.profile_doesnt_exist')}
    end

    def correct_user!
      redirect_to root_path, flash: {error: t('flash.error.other_users_profile')} unless user_signed_in? && current_user == @user
    end

    def associate_beta_invite
      unless session[:beta_invite].nil? || signed_up?(@user)
        @user.beta_invite = BetaInvite.find session[:beta_invite][:id]
        @user.email = session[:beta_invite][:email] if @user.email.blank?
        session[:beta_invite] = nil
      end
    end

    # FIX ME!
    #
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
