class AuthentificationsController < ApplicationController

  def create
    if auth = Authentification.find_by_provider_and_uid(auth_hash.provider, auth_hash.uid)
      user = auth.user
    else
      if user_signed_in?
      	user = create_auth(current_user)
      else
        if session[:devise_controller] == 'registrations'
          user = find_or_create_user_and_auth(make_username(auth_hash.info.nickname, auth_hash.info.name))
        elsif session[:devise_controller] == 'sessions'
          redirect_to new_user_session_path, flash: {error: t('flash.error.social.user_not_found', provider: auth_hash.provider.titleize)}
        end
      end
    end
    redirect_authentified_user(user) if user
  end

  def failure
  	redirect_to new_user_session_path, flash: {error: t('flash.error.something_wrong.auth')}
  end

  def destroy
  	auth = current_user.authentifications.find(params[:id])
    provider = auth.provider.titleize
  	auth.destroy
  	redirect_to edit_user_path(current_user), flash: {success: t('flash.success.provider.removed', provider: provider)}
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
      user = User.find_or_create_by_username(username, username: username, fullname: auth_hash.info.name, remote_image_url: auth_hash.info.image, social: true)
      create_auth(user)
    end

    def redirect_authentified_user(user)
      if user_signed_in?
        if user == current_user
          flash[:success] = t((linkedin_import? == true ? 'flash.success.provider.imported' : 'flash.success.provider.added'), provider: auth_hash.provider.titleize)
        else
          flash[:error] = t('flash.error.other_user.provider', provider: auth_hash.provider.titleize)
        end
        if session[:user_return_to]
          redirect_to(session[:user_return_to]) ; session[:user_return_to] = nil
        else
          redirect_to_back
        end
      else
        sign_in user
        redirect_to root_path, flash: {success: t('devise.omniauth_callbacks.success', provider: auth_hash.provider.titleize)}
      end
    end

    def linkedin_import?
      session[:linkedin_import] && auth_hash.provider == 'linkedin'
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