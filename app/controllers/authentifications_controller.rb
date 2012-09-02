class AuthentificationsController < ApplicationController

  def create
    if user_signed_in?
      if auth = Authentification.find_by_provider_and_uid(auth_hash.provider, auth_hash.uid)
        already_linked(auth.user)
      else
        add_auth
      end
    else
      if auth = Authentification.find_by_provider_and_uid(auth_hash.provider, auth_hash.uid)
        social_sign_in(auth)
      else
        social_sign_up
      end
    end
  end

  def failure
  	redirect_to env['omniauth.origin'], flash: {error: t('flash.error.something_wrong.auth')}
  end

  def destroy
  	auth = current_user.authentifications.find(params[:id])
    provider = auth.provider
    auth.destroy
  	redirect_back flash: {success: t('flash.success.provider.removed', provider: humanize(provider))}
  end

	alias_method :twitter, 			 :create
	alias_method :linkedin, 		 :create
	alias_method :facebook, 		 :create
	alias_method :google_oauth2, :create

  private

    def already_linked(user)
      if user == current_user
        error = 'flash.error.provider.already_linked'
      else
        error = 'flash.error.provider.other_user'
      end
      redirect_to env['omniauth.origin'], flash: {error: t(error, provider: humanize(auth_hash.provider))}
    end

    def add_auth
      create_auth(current_user)
      redirect_to env['omniauth.origin'], flash: {success: t("flash.success.provider.#{add_auth_message(current_user)}", provider: humanize(auth_hash.provider))}
    end

    def add_auth_message(user)
      if env['omniauth.origin'].include?(edit_user_path(user)) && auth_hash.provider == 'linkedin' && !signed_up?(user) then 'imported' else 'added' end
    end

    def social_sign_in(auth)
      if env['omniauth.origin'].include? new_user_session_path
        sign_in auth.user
        redirect_path   = root_path
        flash[:success] = t('flash.success.provider.signed_in', provider: humanize(auth_hash.provider))
      else
        redirect_path = env['omniauth.origin']
        flash[:error] = t('flash.error.provider.other_user_signed_up', provider: humanize(auth_hash.provider))
      end
      redirect_to redirect_path
    end

    def social_sign_up
      if env['omniauth.origin'].include? new_user_registration_path
        sign_in create_user_auth(make_username(auth_hash.info.nickname, auth_hash.info.name))
        redirect_path   = root_path
        flash[:success] = t('flash.success.provider.signed_in', provider: humanize(auth_hash.provider))
      else
        redirect_path = env['omniauth.origin']
        flash[:error] = t('flash.error.provider.no_user', provider: humanize(auth_hash.provider))
      end
      redirect_to redirect_path
    end

    def create_user_auth(username)
      create_auth User.create(username: username, fullname: auth_hash.info.name, remote_image_url: auth_hash.info.image, social: true)
    end

    def create_auth(user)
      user.authentifications.create(provider: auth_hash.provider.to_s.gsub('google_oauth2', 'google'), uid: auth_hash.uid, url: auth_url, utoken: auth_hash.credentials.token, usecret: auth_secret)
      user
    end

    def auth_url
      case auth_hash.provider
        when 'twitter'
          auth_hash.info.urls.Twitter
        when 'linkedin'
          auth_hash.info.urls.public_profile
        when 'facebook'
          auth_hash.info.urls.Facebook
        when 'google'
          auth_hash.extra.raw_info.link
      end
    end

    def auth_secret
      case auth_hash.provider
        when 'linkedin', 'twitter'
          auth_hash.credentials.secret
        when 'facebook', 'google'
          ''
      end
    end

    def humanize(provider)
      provider.gsub('google_oauth2', 'google').titleize
    end

    def auth_hash
      auth_hash = request.env['omniauth.auth']
      auth_hash.provider.gsub!('google_oauth2', 'google')
      auth_hash
    end
end