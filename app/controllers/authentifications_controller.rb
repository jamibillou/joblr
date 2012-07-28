class AuthentificationsController < ApplicationController

  def create
    if omniauth = Authentification.find_by_provider_and_uid(auth_hash.provider, auth_hash.uid)
      user = omniauth.user
    else
      if user = current_user
      	create_omniauth(user)
      else
        user = create_user
      end
    end
    sign_in_and_redirect user
  end

  def failure
  	flash[:error] = t('flash.error.auth_problem', provider: params[:provider])
  	redirect_to new_user_session_path
  end

  def destroy
  	omniauth = current_user.authentifications.find(params[:id])
  	flash[:notice] = t('flash.notice.provider_removed', provider: omniauth.provider.titleize)
  	omniauth.destroy
  	redirect_to edit_user_path(current_user)
  end

	alias_method :twitter, 			 :create
	alias_method :linkedin, 		 :create
	alias_method :facebook, 		 :create
	alias_method :google_oauth2, :create

  private
    def create_user
    	user = User.find_or_create_by_username(build_username,username: build_username,fullname: auth_hash.info.name)
      create_omniauth(user)
    end

    def create_omniauth(user)
    	user.authentifications.create(provider: auth_hash.provider, uid: auth_hash.uid, url: auth_url, upic: auth_hash.info.image)
      user
    end

    def build_username
      unless username = username_available?(initials)
        unless username = username_available?(auth_name)
          username = "user-#{user.id}"
        end
      end
      username
    end

    def username_available?(username)
      username if User.find_by_username(username).nil?
    end

    def initials
      auth_name.split('-').map{ |name| name.chars.first }.join
    end

    def auth_hash
      request.env['omniauth.auth']
    end

    def auth_name
      auth_hash.info.name.parameterize
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
end
