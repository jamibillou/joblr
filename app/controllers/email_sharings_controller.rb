class EmailSharingsController < ApplicationController

	def create
		@user = User.find params[:user_id]
		@email_sharing = EmailSharing.new params[:email_sharing].merge(profile_id: @user.profile, author: (current_user ||= nil))
    unless @email_sharing.save
      respond_to {|format| format.html { render :json => t('flash.error.required.all'), :status => :unprocessable_entity if request.xhr? }}
    else
      respond_to {|format| format.html { send } }
    end
	end

  private

    def send
      if user_signed_in?
        if current_user == @user
          EmailSharingMailer.user(@email_sharing, @user).deliver
        else
          EmailSharingMailer.other_user(@email_sharing, @user, current_user).deliver
        end
      else
        EmailSharingMailer.public_user(@email_sharing, @user).deliver
      end
      flash[:success] = t('flash.success.profile.shared', fullname: user.fullname, recipient_email: email_sharing.recipient_email)
      render :json => 'create!' if request.xhr?
    end
end
