class UsersController < ApplicationController

  before_filter :load_user
  before_filter :profile_completed,     only: :show
  before_filter :correct_user!,         only: [:edit, :update]
  before_filter :associate_beta_invite, only: :update # REFACTOR ME!
  before_filter :admin_user,            only: :destroy

  def show
    @title = @user.fullname
    @email_sharing = EmailSharing.new
    @email_sharing_text = (user_signed_in? && current_user == @user ? t('email_sharings.new.text_user') : t('email_sharings.new.text_other_user'))
  end

  def edit
    unless signed_up?(@user)
      @title = t('users.edit.title_alt')
      @user.profiles.build
      @linkedin = @user.auth('linkedin').profile if @user.has_auth?('linkedin')
    end
  end

  def update
    @title = t('users.update.title_alt') unless signed_up?(@user)
    signed_up = !signed_up?(@user)
    unless @user.update_attributes params[:user]
      flash[:error] = error_messages(@user)
      render :edit, id: @user, user: params[:user]
    else
      remove_files! unless Rails.env.test? # FIX ME!
      redirect_to @user, flash: {success: (signed_up ? t('flash.success.profile.created') : t('flash.success.profile.updated'))}
    end
  end

  def destroy
   User.find(params[:id]).destroy
   redirect_to admin_path, :flash => {:success => t('flash.success.user.destroyed')}
  end

  private

    def correct_user!
      unless current_user == @user
        error = user_signed_in? ? t('flash.error.other_user.profile') : t('flash.error.only.signed_in')
        redirect_to root_path, flash: {error: error}
      end
    end

    # REFACTOR ME!
    #
    # This is as dirty as it gets
    #
    def associate_beta_invite
      unless session[:beta_invite].nil? || signed_up?(@user)
        @user.beta_invite = BetaInvite.find session[:beta_invite][:id]
        @user.email = session[:beta_invite][:email] if @user.email.blank? && User.find_by_email(session[:beta_invite][:email]).nil?
        session[:beta_invite] = nil
      end
    end

    # FIX ME!
    #
    # Kludge until https://github.com/jnicklas/carrierwave/pull/712 is included the gem
    # Still doesn't work though: the file is deleted as excpected but the column isn't emptied.
    # This isn't needed anyway, :remove_#{attr} check_box should do this automatically.
    # Weirdly it only works for the image, with the above bug of course...
    #
    def remove_files!
      remove_file! @user.profile
      remove_image! @user
    end
    #
    def remove_file!(profile)
      if params[:user][:profiles_attributes]['0'][:remove_file] == '1'
        profile.remove_file = true
        profile.save
      end
    end
    #
    def remove_image!(user)
      if params[:user][:remove_image] == '1'
        user.remove_image = true
        user.save
      end
    end
end
