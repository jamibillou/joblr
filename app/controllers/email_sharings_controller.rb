class EmailSharingsController < ApplicationController

	before_filter :find_user, :access_to_profile, :signed_up, only: :new

  def new
		@email_sharing = EmailSharing.new
	end

	def create
		@user = User.find(params[:user_id])
		@email_sharing = EmailSharing.new(params[:email_sharing].merge(profile_id: @user.profile, author: current_user))
		unless @email_sharing.save
      flash[:error] = error_messages(@email_sharing)
      render :new, id: @user.id
		else
			UserMailer.share_profile(@email_sharing).deliver
	  	redirect_to @user, flash: {success: t('flash.success.profile.shared')}
		end
	end
end
