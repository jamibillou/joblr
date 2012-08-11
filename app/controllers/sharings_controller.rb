class SharingsController < ApplicationController
  include AuthentificationsHelper

	def new
		@user = current_user
		@sharing = Sharing.new
    redirect_to edit_user_path(@user) unless signed_up?(@user)
	end

	def create
		if params[:email].blank?
			redirect_to new_sharing_path, flash: { error: t('flash.error.email_missing')}
		else
			unless @recipient = User.find_or_create_by_email(params[:email], username: build_username_with_email(params[:email]), fullname: params[:fullname], role: params[:role], company: params[:company])
				redirect_to new_sharing_path, flash: { error: error_messages(@recipient)}
			else				
				@sharing = Sharing.new params[:sharing]
				@sharing.recipient = @recipient
				unless @sharing.save
					redirect_to new_sharing_path, flash: { error: error_messages(@sharing)}
				else
					UserMailer.share_profile(@sharing).deliver
		    	redirect_to @sharing.author, flash: { success: t('flash.success.profile_shared') }
				end	
			end
		end
	end

	private

		def build_username_with_email(email)
			unless username = username_available?(email.split('@').first)
				username = "user-#{User.last.id+1}"
			end
			username
		end
end
