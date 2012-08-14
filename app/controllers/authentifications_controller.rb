class AuthentificationsController < ApplicationController
  include AuthentificationsHelper
  include UsersHelper

  def create
    if auth = Authentification.find_by_provider_and_uid(auth_hash.provider, auth_hash.uid)
      user = auth.user
    else
      if user = current_user
      	create_auth(user)
      else
        user = find_create_user_auth(build_username)
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
  	auth = current_user.authentifications.find(params[:id])
    provider = auth.provider.titleize
  	auth.destroy
  	redirect_to edit_user_path(current_user), flash: { success: t('flash.notice.provider_removed', provider: provider) }
  end

	alias_method :twitter, 			 :create
	alias_method :linkedin, 		 :create
	alias_method :facebook, 		 :create
	alias_method :google_oauth2, :create

  private

    def find_create_user_auth(username)
      user = User.find_or_create_by_username(username, username: username, fullname: auth_hash.info.name, remote_image_url: auth_hash.info.image)
      create_auth(user)
    end

    def create_auth(user)
      user.authentifications.create(provider: auth_hash.provider, uid: auth_hash.uid, url: public_url, utoken: auth_hash.credentials.token, usecret: auth_secret)
      user
    end

end