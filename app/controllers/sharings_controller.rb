class SharingsController < ApplicationController
  include AuthentificationsHelper

	def new
		@user = User.find params[:id]
		@sharing = Sharing.new
    redirect_to edit_user_path(@user) unless signed_up?(@user)
	end

	def create
		## to be changed
		if @recipient = find_or_create_recipient
			@sharing = Sharing.new(params[:sharing].merge recipient_id: @recipient.id)
			unless @sharing.save
				redirect_to new_sharing_path(id: params[:sharing][:author_id]), flash: { error: error_messages(@sharing) }
			else
				UserMailer.share_profile(@sharing).deliver
		  	redirect_to @sharing.author, flash: { success: t('flash.success.profile_shared') }
			end
		end
	end

	def linkedin
		@user = User.find params[:sharing][:user_id]
		error = params[:sharing][:text].blank? ? t('flash.error.text.blank') : (t('flash.error.text.long') if params[:sharing][:text].length > 140)
    unless error
      current_user.linkedin_share title: "#{@user.fullname} on Joblr", comment: params[:sharing][:text], url: root_url(subdomain: @user.subdomain), image_url: "http://#{request.domain}#{@user.image_url.to_s}"
      redirect_to root_path, flash: { success: t('flash.success.profile_shared') }
    else
    	redirect_to new_sharing_path(id: @user.id, provider: 'linkedin'), flash: { error: error }
		end
	end

	private

		def build_username_with_email(email)
			unless username = username_available?(email.split('@').first)
				username = "user-#{User.last.id + 1}"
			end
			username
		end

		def find_or_create_recipient
			## to be deleted
			unless recipient = User.find_by_email(params[:email], conditions: "email != ''")
				recipient = User.new(email: params[:email], username: build_username_with_email(params[:email]))
				recipient.email_will_change!
				unless recipient.save
					redirect_to new_sharing_path(id: params[:sharing][:author_id]), flash: { error: error_messages(recipient) } and return nil
				end
			end
			recipient		
		end
end
