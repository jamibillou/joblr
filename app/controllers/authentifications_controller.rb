class AuthentificationsController < ApplicationController

  def create
    user = if auth = Authentification.find_by_provider_and_uid(auth_hash.provider, auth_hash.uid)
      auth.user
    else
      if user_signed_in?
      	create_auth(current_user)
      else
        find_or_create_user_and_auth(make_username(auth_hash.info.nickname, auth_hash.info.name))
      end
    end
    redirect_authentified_user(user)
  end

  def failure
  	redirect_to new_user_session_path, flash: { error: t('flash.error.auth_problem', provider: params[:provider]) }
  end

  def destroy
  	auth = current_user.authentifications.find(params[:id])
    provider = auth.provider.titleize
  	auth.destroy
  	redirect_to edit_user_path(current_user), flash: { success: t('flash.success.provider_removed', provider: provider) }
  end

	alias_method :twitter, 			 :create
	alias_method :linkedin, 		 :create
	alias_method :facebook, 		 :create
	alias_method :google_oauth2, :create

  private

    def create_auth(user)
      user.authentifications.create(provider: auth_hash.provider, uid: auth_hash.uid, url: auth_url, utoken: auth_hash.credentials.token, usecret: auth_secret)
      user
    end

    def find_or_create_user_and_auth(username)
      user = User.find_or_create_by_username(username, username: username, fullname: auth_hash.info.name, remote_image_url: auth_hash.info.image)
      create_auth(user)
    end

    def redirect_authentified_user(user)
      if user_signed_in?
        if user == current_user
          redirect_to edit_user_path(user), flash: { success: t('flash.success.provider_added', provider: auth_hash.provider.titleize) }
        else
          redirect_to edit_user_path(current_user), flash: { error: t('flash.error.other_users_provider', provider: auth_hash.provider.titleize) }
        end
      else
        sign_in user
        redirect_to root_path, flash: { success: t('devise.omniauth_callbacks.success', provider: auth_hash.provider.titleize) }
      end
    end

    def auth_url
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

    def auth_secret
      case auth_hash.provider
        when 'linkedin', 'twitter'
          auth_hash.credentials.secret
        when 'facebook', 'google_oauth2'
          ''
      end
    end

    def auth_hash
      request.env['omniauth.auth']
    end
end