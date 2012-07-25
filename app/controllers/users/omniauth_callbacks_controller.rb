class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def all
    omniauth = request.env['omniauth.auth']
    user = User.from_omniauth(omniauth)
    if user.persisted?
      flash[:notice] = "Signed in successfully using #{auth_info[:provider].titleize}!"
      sign_in_and_redirect edit_user_path(user)
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to new_user_registration_url
    end
  end

  def linkedin
    omniauth = request.env['omniauth.auth']
    auth_info = {}
    if omniauth
      omniauth['info']['name'] ? auth_info[:name] = omniauth['info']['name'] : auth_info[:name] = ''
      omniauth['extra']['raw_info']['id'] ?  auth_info[:uid] =  omniauth['extra']['raw_info']['id'] : auth_info[:uid] = ''
      omniauth['provider'] ? auth_info[:provider] =  omniauth['provider'] : auth_info[:provider] = ''
      omniauth['info']['image'] ?  auth_info[:upic] =  omniauth['info']['image'] : auth_info[:upic] = ''
      omniauth['info']['urls']['public_profile'] ? auth_info[:url] =  omniauth['info']['urls']['public_profile'] : auth_info[:url] = ''
      connect(auth_info)      
    else
      render :text => 'Omniauth is empty :/'
    end
  end

  def facebook
    omniauth = request.env['omniauth.auth']
    auth_info = {}
    if omniauth
      omniauth['extra']['raw_info']['email'] ? email =  omniauth['extra']['raw_info']['email'] : email = ''
      omniauth['extra']['raw_info']['name'] ? auth_info[:name] =  omniauth['info']['name'] : auth_info[:name] = ''
      omniauth['extra']['raw_info']['id'] ?  auth_info[:uid] =  omniauth['extra']['raw_info']['id'] : auth_info[:uid] = ''
      omniauth['provider'] ? auth_info[:provider] =  omniauth['provider'] : auth_info[:provider] = ''
      omniauth['info']['image'] ?  auth_info[:upic] =  omniauth['info']['image'] : auth_info[:upic] = ''
      omniauth['info']['urls']['Facebook'] ? auth_info[:url] =  omniauth['info']['urls']['Facebook'] : auth_info[:url] = ''
      connect(auth_info)
    else
      render :text => 'Omniauth is empty :/'
    end   
  end

#  def twitter
#    omniauth = request.env['omniauth.auth']
#    auth_info = {}
#    if omniauth
#      omniauth['info']['name'] ? auth_info[:name] =  omniauth['info']['name'] : auth_info[:name] = ''
#      omniauth['extra']['raw_info']['id'] ?  auth_info[:uid] =  omniauth['extra']['raw_info']['id'] : auth_info[:uid] = ''
#      omniauth['provider'] ? auth_info[:provider] =  omniauth['provider'] : auth_info[:provider] = ''
#      omniauth['info']['image'] ?  auth_info[:upic] =  omniauth['info']['image'] : auth_info[:upic] = ''
#      omniauth['info']['urls']['Twitter'] ? auth_info[:url] =  omniauth['info']['urls']['Twitter'] : auth_info[:url] = ''
#      connect(auth_info)      
#    else
#      render :text => 'Omniauth is empty :/'
#    end  
#  end

  def google_oauth2
    omniauth = request.env['omniauth.auth']
    auth_info = {}
    if omniauth
      omniauth['info']['email'] ? email =  omniauth['info']['email'] : email = ''
      omniauth['info']['name'] ? auth_info['name'] =  omniauth['info']['name'] : auth_info['name'] = ''
      omniauth['uid'] ? auth_info[:uid] =  omniauth['uid'] : auth_info[:uid] = ''
      omniauth['provider'] ? auth_info[:provider] =  'google' : auth_info[:provider] = ''
      omniauth['info']['image'] ?  auth_info[:upic] =  omniauth['info']['image'] : auth_info[:upic] = ''
      omniauth['extra']['raw_info']['link'] ?  auth_info[:url] =  omniauth['extra']['raw_info']['link'] : auth_info[:url] = ''
      connect(auth_info)
    else
      render :text => 'Omniauth is empty :/'
    end       
  end

  alias_method :twitter, :all
  alias_method :google_oauth2, :all
  alias_method :linkedin, :all
  alias_method :facebook, :all

  private

    def connect(auth_info)
      if auth_info[:uid] != '' && auth_info[:provider] != ''
        unless user_signed_in?
          auth = Authentification.find_by_uid_and_provider(auth_info[:uid].to_s, auth_info[:provider])
          if auth
            flash[:notice] = "Signed in successfully using #{auth_info[:provider].titleize}!"
            sign_in auth.user
            redirect_to auth.user
          else
            existing_user = User.find_by_email(auth_info[:email])
            if existing_user
              existing_user.authentifications.create(provider: auth_info[:provider], uid: auth_info[:uid], uname: auth_info[:name], 
                uemail: auth_info[:email], url: auth_info[:url], upic: auth_info[:upic])
              flash[:notice] = "You can now sign in with #{auth_info[:provider].titleize} too!"
            else
              user = User.new :fullname => auth_info[:name], :email => auth_info[:email]
              user.save!
              user.authentifications.create(provider: auth_info[:provider], uid: auth_info[:uid], uname: auth_info[:name], 
                uemail: auth_info[:email], url: auth_info[:url], upic: auth_info[:upic])
              
              flash[:notice] = "Account created via #{auth_info[:provider].titleize}!"
              sign_in user
              redirect_to user
            end
          end
        else
          auth = Authentification.find_by_uid_and_provider(auth_info[:uid].to_s, auth_info[:provider])
          if auth
            flash[:notice] = "#{auth_info[:provider].titleize} is already linked to your account."
            redirect_to edit_user_path(current_user)
          else
            current_user.authentifications.create(provider: auth_info[:provider], uid: auth_info[:uid], uname: auth_info[:name], 
              uemail: auth_info[:email], url: auth_info[:url], upic: auth_info[:upic])
            current_user.update_attribute(:email,auth_info[:email]) if(auth_info[:email] != "" && current_user.email == "") 
            flash[:notice] = "You added your #{auth_info[:provider].titleize} account to your profile."
            redirect_to edit_user_path(current_user)
          end 
        end
      else
        flash[:error] =  authentification_route.capitalize + ' returned invalid data for the user id.'
        redirect_to new_user_session_path
      end
    end
end
