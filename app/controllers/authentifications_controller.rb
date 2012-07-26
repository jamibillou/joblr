class AuthentificationsController < ApplicationController

  def create
    if omniauth = Authentification.find_by_provider_and_uid(auth_hash.provider, auth_hash.uid)
      user = omniauth.user
    else
      if user = current_user || user = User.find_by_username(create_username)
      	create_omniauth(user)      	
      else
        user = create_user
      end
    end
    sign_in_and_redirect user
  end

  def failure
  	flash[:error] = "Pb during the connexion with #{params[:provider]}"
  	redirect_to new_user_session_path
  end

  def destroy
  	@authentification = current_user.authentifications.find(params[:id])
  	flash[:notice] = "You removed your #{@authentification.provider.titleize} account to your profile."
  	@authentification.destroy
  	redirect_to edit_user_path(current_user)
  end

	alias_method :twitter, 			 :create
	alias_method :linkedin, 		 :create
	alias_method :facebook, 		 :create
	alias_method :google_oauth2, :create

  private
    def create_user
    	session["uid"] = auth_hash.uid
    	user = User.create!(username: create_username, fullname: auth_hash.info.name, password: Devise.friendly_token.first(6))
      create_omniauth(user)
      user
    end

    def create_omniauth(user)
    	user.authentifications.create(provider: auth_hash.provider, uid: auth_hash.uid)
    end

    def create_username
    	auth_hash.info.name.split.first.first.downcase+auth_hash.info.name.split.last.downcase
    end	

    def auth_hash
      request.env['omniauth.auth']
    end
end
