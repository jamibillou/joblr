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
  	redirect_to auth_origin, flash: {error: t('flash.error.something_wrong.auth')}
  end

  def destroy
  	auth = Authentification.find(params[:id]) ; user = auth.user ; provider = auth.provider
    auth.destroy
    user.update_attributes social: false if user.authentifications.empty?
  	redirect_to_back flash: {success: t('flash.success.provider.removed', provider: humanize(provider))}
  end

	alias_method :twitter, 			 :create
	alias_method :linkedin, 		 :create
	alias_method :facebook, 		 :create
	alias_method :google_oauth2, :create

  private

    def already_linked(user)
      if user == current_user
        flash[:error] = t('flash.error.provider.already_linked', provider: humanize(auth_hash.provider))
      else
        flash[:error] = t('flash.error.provider.other_user', provider: humanize(auth_hash.provider))
      end
      redirect_to auth_origin
    end

    def add_auth
      create_auth(current_user)
      redirect_to auth_origin, flash: {success: t("flash.success.provider.#{add_auth_message(current_user)}", provider: humanize(auth_hash.provider))}
    end

    def add_auth_message(user)
      if auth_origin.include?(edit_user_path(user)) && auth_hash.provider == 'linkedin' && !signed_up?(user) then 'imported' else 'added' end
    end

    def social_sign_in(auth)
      if auth_origin.include? new_user_session_path
        sign_in auth.user
        redirect_path   = root_path
        flash[:success] = t('flash.success.provider.signed_in', provider: humanize(auth_hash.provider))
      else
        redirect_path = auth_origin
        flash[:error] = t('flash.error.provider.other_user_signed_up', provider: humanize(auth_hash.provider))
      end
      redirect_to redirect_path
    end

    def social_sign_up
      if auth_origin.include? new_user_registration_path
        sign_in create_user_auth(User.make_username(auth_hash.info.nickname, auth_hash.info.name))
        redirect_path   = root_path
        flash[:success] = t('flash.success.provider.signed_up', provider: humanize(auth_hash.provider))
      else
        redirect_path = auth_origin
        flash[:error] = t('flash.error.provider.no_user', provider: humanize(auth_hash.provider))
      end
      redirect_to redirect_path
    end

    def create_user_auth(username)
      create_auth User.create(username: username, fullname: auth_hash.info.name, remote_image_url: auth_hash.info.image)
    end

    def create_auth(user)
      user.update_attributes social: true unless user.social?
      user.authentifications.create(provider: auth_hash.provider, uid: auth_hash.uid, url: auth_url, utoken: auth_token, usecret: auth_secret)
      user
    end

    def auth_url
      case auth_hash.provider
        when 'twitter'
          auth_hash.info.urls.Twitter        unless auth_hash.info.urls.nil?
        when 'linkedin'
          auth_hash.info.urls.public_profile unless auth_hash.info.urls.nil?
        when 'facebook'
          auth_hash.info.urls.Facebook       unless auth_hash.info.urls.nil?
        when 'google_oauth2'
          auth_hash.extra.raw_info.link      unless auth_hash.extra.raw_info.nil?
      end
    end

    def auth_token
      auth_hash.credentials.token unless auth_hash.credentials.nil?
    end

    def auth_secret
      case auth_hash.provider
        when 'linkedin', 'twitter'
          auth_hash.credentials.secret unless auth_hash.credentials.nil?
        when 'facebook', 'google_oauth2'
          ''
      end
    end

    def auth_hash
      auth_hash = request.env['omniauth.auth']
      #auth_hash.provider.gsub!('google_oauth2', 'google')
      auth_hash
    end

    def auth_origin
      unless request.env['omniauth.origin'].nil?
        request.env['omniauth.origin']
      else
        root_path
      end
    end

    def humanize(provider)
      provider.gsub('google_oauth2', 'google').titleize
    end
end