class AuthentificationsController < ApplicationController

  include AuthentificationsHelper

  def create
    if omniauth = Authentification.find_by_provider_and_uid(auth_hash.provider, auth_hash.uid)
      user = omniauth.user
    else
      if user = current_user
      	create_omniauth(user)
      else
        user = find_or_create_user(build_username)
      end
    end
    if user_signed_in?
      redirect_to edit_user_path(user), flash: { notice: t('flash.notice.provider_added', provider: auth_hash.provider.titleize) }
    else
      sign_in user
      redirect_to user, flash: { notice: t('devise.omniauth_callbacks.success', provider: auth_hash.provider.titleize) }
    end
  end

  def failure
  	redirect_to new_user_session_path, flash: { error: t('flash.error.auth_problem', provider: params[:provider]) }
  end

  def destroy
  	omniauth = current_user.authentifications.find(params[:id])
    provider = omniauth.provider.titleize
  	omniauth.destroy
  	redirect_to edit_user_path(current_user), flash: { success: t('flash.notice.provider_removed', provider: provider) }
  end

	alias_method :twitter, 			 :create
	alias_method :linkedin, 		 :create
	alias_method :facebook, 		 :create
	alias_method :google_oauth2, :create

  private
    def find_or_create_user(username)
      user = User.find_or_create_by_username(username, username: username, fullname: auth_hash.info.name,
                                                       remote_image_url: image_url('original', auth_hash.uid, auth_hash.provider, auth_hash.info.image))
      create_omniauth(user)
    end

    def build_username
      unless username = username_available?(auth_hash.info.nickname)
        unless username = username_available?(initials)
          unless username = username_available?(dashed_fullname)
            username = "user-#{user.id}"
          end
        end
      end
      username
    end

    def username_available?(username)
      username if User.find_by_username(username).nil?
    end

    def initials
      dashed_fullname.split('-').map{ |name| name.chars.first }.join
    end

    def dashed_fullname
      auth_hash.info.name.parameterize
    end

    def create_omniauth(user)
      user.authentifications.create(provider: auth_hash.provider, uid: auth_hash.uid, url: url)
      user
    end

    def auth_hash
      request.env['omniauth.auth']
    end

    def url
      case auth_hash.provider
        when 'twitter'
          auth_hash.info.urls.Twitter
        when 'linkedin'
          auth_hash.info.urls.public_profile
        when 'facebook'
          auth_hash.info.urls.Facebook
        when 'google_oauth2'
          auth_hash.extra.raw_info.link
      end
    end
end
