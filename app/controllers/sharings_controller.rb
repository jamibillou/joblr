class SharingsController < ApplicationController

	def new
		@user = User.find params[:id]
		@sharing = Sharing.new
    redirect_to edit_user_path(@user) unless signed_up?(@user)
	end

	def create
		if params[:email].blank?
			redirect_to new_sharing_path(id: params[:sharing][:author_id]), flash: { error: t('flash.error.email_missing') }
		else
			unless @recipient = User.find_or_create_by_email(params[:email], username: build_username_with_email(params[:email]), fullname: params[:fullname])
				redirect_to new_sharing_path(id: params[:sharing][:author_id]), flash: { error: error_messages(@recipient) }
			else
				@sharing = Sharing.new(params[:sharing].merge recipient_id: @recipient.id)
				unless @sharing.save
					redirect_to new_sharing_path(id: params[:sharing][:author_id]), flash: { error: error_messages(@sharing) }
				else
					UserMailer.share_profile(@sharing).deliver
		    	redirect_to @sharing.author, flash: { success: t('flash.success.profile_shared') }
				end
			end
		end
	end

	def linkedin
		@user = User.find params[:sharing][:user_id]
    unless errors = validation_errors(:text, params[:sharing][:text], presence: true, length: { maximum: 140 })
      current_user.auth('linkedin').share comment: params[:sharing][:text], title: "#{@user.fullname} on Joblr", description: @user.profile.text, url: root_url(subdomain: @user.subdomain), image_url: "http://#{request.domain}#{@user.image_url.to_s}"
      redirect_to root_path, flash: { success: t('flash.success.profile_shared') }
    else
    	redirect_to new_sharing_path(id: @user.id, provider: 'linkedin'), flash: { error: errors }
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
