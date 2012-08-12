class SharingsController < ApplicationController
  include AuthentificationsHelper

	def new
		@user = User.find params[:id]
		@sharing = Sharing.new
    redirect_to edit_user_path(@user) unless signed_up?(@user)
	end

	def create
		if params[:email].blank?
			redirect_to new_sharing_path, flash: { error: t('flash.error.email_missing') }
		else
			unless @recipient = User.find_or_create_by_email(params[:email], username: build_username_with_email(params[:email]), fullname: params[:fullname], role: params[:role], company: params[:company])
				redirect_to new_sharing_path, flash: { error: error_messages(@recipient) }
			else
				@sharing = Sharing.new params[:sharing]
				@sharing.recipient = @recipient
				unless @sharing.save
					redirect_to new_sharing_path, flash: { error: error_messages(@sharing) }
				else
					UserMailer.share_profile(@sharing).deliver
		    	redirect_to @sharing.author, flash: { success: t('flash.success.profile_shared') }
				end
			end
		end
	end

	def linkedin
		@user = User.find(params[:sharing][:user_id])
		unless params[:sharing][:text].blank? || params[:sharing][:text].length > 140
      current_user.linkedin_share title: "#{@user.fullname}'s profile on Joblr", comment: params[:sharing][:text], url: root_url(subdomain: @user.subdomain), image_url: @user.image_url.to_s
      redirect_to root_path, flash: { success: t('flash.success.profile_shared') }
    else
    	redirect_to new_sharing_path(id: @user.id, provider: 'linkedin'), flash: { error: "Text format is incorrect (can't be blank or over 140 characters)" }
		end
	end

	private

		def build_username_with_email(email)
			unless username = username_available?(email.split('@').first)
				username = "user-#{User.last.id + 1}"
			end
			username
		end
end
