class EmailSharingsController < ApplicationController

  before_filter :load_email_sharing, except: :create

	def create
		@user = User.find params[:user_id]
		@email_sharing = EmailSharing.new params[:email_sharing].merge(profile: @user.profile, author: current_user)
    unless @email_sharing.save
      respond_to {|format| format.html { render :json => t('flash.error.required.all'), :status => :unprocessable_entity if request.xhr? }}
    else
      respond_to {|format| format.html { deliver_email_sharing } }
    end
	end

  def decline
    unless @email_sharing.status.nil?
      redirect_to email_sharing_already_answered_path
    else
      @email_sharing.update_attributes status: 'declined'
      deliver_decline
    end
  end

  private

    def deliver_email_sharing
      if user_signed_in?
        if current_user == @user
          EmailSharingMailer.user(@email_sharing, @user).deliver
        else
          EmailSharingMailer.other_user(@email_sharing, @user, current_user).deliver
        end
      else
        EmailSharingMailer.public_user(@email_sharing, @user).deliver
      end
      flash[:success] = t('flash.success.profile.shared', recipient_email: @email_sharing.recipient_email)
      render :json => 'create!' if request.xhr?
    end

    def deliver_decline
      if @email_sharing.author == @email_sharing.profile.user
        EmailSharingMailer.decline(@email_sharing).deliver
      else
        EmailSharingMailer.decline_through_other(@email_sharing).deliver
      end
    end

    def load_email_sharing
      @email_sharing = EmailSharing.find(params[:email_sharing_id])
    end
end
