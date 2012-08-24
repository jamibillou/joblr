class SharingsController < ApplicationController

	before_filter :find_user, :signed_up, only: :new
  before_filter :authenticate,          only: :linkedin

  def new
		@sharing = Sharing.new
	end

	def create
		unless errors = validation_errors(:email, params[:email],presence:true, uniqueness:true, email_format: { with: Devise.email_regexp })
			@recipient = User.find_or_create_by_email(params[:email], fullname: params[:fullname], username: sharing_username)
			@sharing = Sharing.new(params[:sharing].merge recipient_id: @recipient.id)
			unless @sharing.save
				redirect_to new_sharing_path(id: params[:sharing][:author_id]), flash: { error: error_messages(@sharing) }
			else
				UserMailer.share_profile(@sharing).deliver
		  	redirect_to @sharing.author, flash: { success: t('flash.success.profile.shared') }
			end
		else
			redirect_to new_sharing_path(id: params[:sharing][:author_id]), flash: { error: errors }
		end
	end

	def linkedin
		@user = User.find params[:sharing][:user_id]
    unless errors = validation_errors(:text, params[:sharing][:text], presence: true, length: { maximum: 140 })
      current_user.auth('linkedin').share comment: params[:sharing][:text], title: t('sharings.social_title', fullname: @user.fullname), description: @user.profile.text, url: root_url(subdomain: @user.subdomain), image_url: "http://#{request.domain}#{@user.image_url.to_s}"
      redirect_to root_path, flash: { success: t('flash.success.profile.shared') }
    else
    	redirect_to new_sharing_path(id: @user.id, provider: 'linkedin'), flash: { error: errors }
		end
	end

	private

    def authenticate
      # FIX ME! needs to handle non signed in users
      session[:user_return_to] = sharings_linkedin_path(sharing: params[:sharing])
      if !user_signed_in?
        redirect_to root_path, flash: {error: t('flash.error.something_wrong.base')}
      elsif current_user.auth('linkedin').nil?
        redirect_to omniauth_authorize_path(current_user, 'linkedin') if current_user.auth('linkedin').nil?
      end
    end

	  def sharing_username
	  	make_username(params[:email].split('@').first, params[:fullname])
	  end
end
