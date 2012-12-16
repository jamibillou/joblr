class SharingEmailsController < ApplicationController

  before_filter :load_sharing_email, except: :create

	def create
		@user = User.find params[:user_id]
		@sharing_email = SharingEmail.new params[:sharing_email].merge(profile: @user.profile, author: current_user)
    unless @sharing_email.save
      respond_to {|format| format.html { render :json => error_messages(@sharing_email), :status => :unprocessable_entity if request.xhr? }}
    else
      respond_to {|format| format.html { deliver_sharing_email } }
    end
	end

  def decline
    unless @sharing_email.status.nil?
      redirect_to sharing_email_already_answered_path
    else
      @sharing_email.update_attributes status: 'declined'
      deliver_decline
    end
  end

  private

    def deliver_sharing_email
      if user_signed_in?
        if current_user == @user
          SharingEmailMailer.user(@sharing_email, @user).deliver
          flash[:success] = t('flash.success.profile.shared.user', recipient_email: @sharing_email.recipient_email)
        else
          SharingEmailMailer.other_user(@sharing_email, @user, current_user).deliver
          flash[:success] = t('flash.success.profile.shared.other_user', recipient_email: @sharing_email.recipient_email, fullname: @user.fullname)
        end
      else
        SharingEmailMailer.public_user(@sharing_email, @user).deliver
        flash[:success] = t('flash.success.profile.shared.public_user', recipient_email: @sharing_email.recipient_email, fullname: @user.fullname)
      end
      render :json => 'create!' if request.xhr?
    end

    def deliver_decline
      if @sharing_email.author == @sharing_email.profile.user
        SharingEmailMailer.decline(@sharing_email).deliver
      else
        SharingEmailMailer.decline_through_other(@sharing_email).deliver
      end
    end

    def load_sharing_email
      @sharing_email = SharingEmail.find(params[:sharing_email_id])
    end
end
