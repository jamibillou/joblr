class ProfileEmailsController < ApplicationController

  before_filter :load_profile_email,                                only: [:decline, :already_answered]
  before_filter :signed_in,                                         only: [:new, :index]
  before_filter :not_answered,                                      only: :decline
  before_filter :has_profile_emails,                                only: :index
  before_filter :admin_user,                                        only: :destroy
  before_filter :load_user, :profile_completed, :no_profile_emails, only: :new

  def new
    @user = current_user
    @profile_email = ProfileEmail.new author: current_user, profile: current_user.profile
  end

	def create
		@user = User.find params[:user_id]
		@profile_email = ProfileEmail.new params[:profile_email].merge(profile: @user.profile, author: current_user)
    unless @profile_email.save
      respond_to {|format| format.html { render :json => error_messages(@profile_email), :status => :unprocessable_entity if request.xhr? }}
    else
      respond_to {|format| format.html { deliver_profile_email } }
    end
	end

  def decline
    @profile_email.update_attributes status: 'declined'
    deliver_decline
  end

  def index
    @profile_emails         = current_user.authored_profile_emails
    @profile_emails_by_date = current_user.authored_profile_emails_by_date
  end

  def destroy
   ProfileEmail.find(params[:id]).destroy
   redirect_to admin_path, flash: {success: t('flash.success.profile_email.destroyed')}
  end

  private

    def deliver_profile_email
      if user_signed_in?
        if current_user == @user
          ProfileEmailMailer.current_user(@profile_email, @user).deliver
          flash[:success] = t('flash.success.profile.shared.user', recipient_email: @profile_email.recipient_email)
        else
          ProfileEmailMailer.other_user(@profile_email, @user, current_user).deliver
          flash[:success] = t('flash.success.profile.shared.other_user', recipient_email: @profile_email.recipient_email, fullname: @user.fullname)
        end
      else
        ProfileEmailMailer.public_user(@profile_email, @user).deliver
        flash[:success] = t('flash.success.profile.shared.public_user', recipient_email: @profile_email.recipient_email, fullname: @user.fullname)
      end
      render :json => 'create!' if request.xhr?
    end

    def deliver_decline
      if @profile_email.author == @profile_email.profile.user
        ProfileEmailMailer.decline(@profile_email).deliver
      else
        ProfileEmailMailer.decline_through_other(@profile_email).deliver
      end
    end

    def load_profile_email
      @profile_email = ProfileEmail.find(params[:profile_email_id])
    end

    def not_answered
      redirect_to profile_email_already_answered_path unless @profile_email.status.nil?
    end

    def has_profile_emails
      redirect_to root_path, flash: {error: t('flash.error.profile_email.none')} unless current_user.has_authored_profile_emails?
    end

    def no_profile_emails
      redirect_to root_path, flash: {error: t('flash.error.profile_email.already_sent')} if current_user.activated?
    end
end
