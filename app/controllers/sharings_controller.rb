class SharingsController < ApplicationController

	def new
		@user = current_user
		@sharing = Sharing.new
	end

	def create
		@sharing = Sharing.new params[:sharing]
		unless @sharing.save
			redirect_to new_sharing_path, flash: { error: error_messages(@sharing)}
		else
			UserMailer.share_profile(@sharing).deliver
    	redirect_to @sharing.user, flash: { success: t('flash.success.profile_shared') }
		end	
	end
end
