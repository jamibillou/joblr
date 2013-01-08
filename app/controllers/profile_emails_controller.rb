class ProfileEmailsController < ApplicationController

  before_filter :load_profile_email, except: [:create, :index]
  before_filter :signed_in,          only: :index

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
    unless @profile_email.status.nil?
      redirect_to profile_email_already_answered_path
    else
      @profile_email.update_attributes status: 'declined'
      deliver_decline
    end
  end

  def index
    @dates = current_user.profile_emails.order('created_at DESC').map{|pe| {month: pe.created_at.month, year: pe.created_at.year}}.uniq
  end

  private

    def deliver_profile_email
      if user_signed_in?
        if current_user == @user
          ProfileEmailMailer.user(@profile_email, @user).deliver
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
end
