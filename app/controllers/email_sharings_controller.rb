class EmailSharingsController < ApplicationController

	before_filter :load_user, :profile_completed, only: :new

  def new
		@email_sharing = EmailSharing.new
	end

	def create
		@user = User.find params[:user_id]
		@email_sharing = EmailSharing.new params[:email_sharing].merge(profile_id: @user.profile, author: current_user)
    unless @email_sharing.save
      respond_to {|format| format.html { render :json => t('flash.error.required.all'), :status => :unprocessable_entity if request.xhr? }}
    else
      respond_to do |format|
      	format.html do
      		UserMailer.share_profile(@email_sharing, @user).deliver
      		flash[:success] = t('flash.success.profile.shared')
      	  render :json => 'create!' if request.xhr?
      	end
      end
    end
	end
end
