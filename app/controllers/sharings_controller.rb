class SharingsController < ApplicationController

	def new
		@user = User.find params[:id]
		@sharing = Sharing.new
    redirect_to edit_user_path(@user) unless signed_up?(@user)
	end

	def create
		unless errors = validation_errors(:email, params[:email],presence:true, uniqueness:true, email_format: { with: Devise.email_regexp })
			@recipient = User.find_or_create_by_email(params[:email], fullname: params[:fullname], username: sharing_username)
			@sharing = Sharing.new(params[:sharing].merge recipient_id: @recipient.id)
			unless @sharing.save
				redirect_to new_sharing_path(id: params[:sharing][:author_id]), flash: { error: error_messages(@sharing) }
			else
				UserMailer.share_profile(@sharing).deliver
		  	redirect_to @sharing.author, flash: { success: t('flash.success.profile_shared') }
			end
		else
			redirect_to new_sharing_path(id: params[:sharing][:author_id]), flash: { error: errors }
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
	  def sharing_username
	  	build_username(params[:email].split('@').first, params[:fullname])
	  end
end
