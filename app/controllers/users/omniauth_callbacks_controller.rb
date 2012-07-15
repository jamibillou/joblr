class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def linkedin
    omniauth = request.env['omniauth.auth']
    if omniauth
      omniauth['info']['name'] ? name =  omniauth['info']['name'] : name = ''
      omniauth['extra']['raw_info']['id'] ?  uid =  omniauth['extra']['raw_info']['id'] : uid = ''
      omniauth['provider'] ? provider =  omniauth['provider'] : provider = ''
      connect(name, uid, provider)      
    else
      render :text => 'Omniauth is empty :/'
    end
  end

  def facebook
    omniauth = request.env['omniauth.auth']
    if omniauth
      omniauth['extra']['raw_info']['email'] ? email =  omniauth['extra']['raw_info']['email'] : email = ''
      omniauth['extra']['raw_info']['name'] ? name =  omniauth['info']['name'] : name = ''
      omniauth['extra']['raw_info']['id'] ?  uid =  omniauth['extra']['raw_info']['id'] : uid = ''
      omniauth['provider'] ? provider =  omniauth['provider'] : provider = ''
      connect(name, uid, provider, email)
    else
      render :text => 'Omniauth is empty :/'
    end   
  end

  def twitter
    omniauth = request.env['omniauth.auth']
    if omniauth
      omniauth['info']['name'] ? name =  omniauth['info']['name'] : name = ''
      omniauth['extra']['raw_info']['id'] ?  uid =  omniauth['extra']['raw_info']['id'] : uid = ''
      omniauth['provider'] ? provider =  omniauth['provider'] : provider = ''
      connect(name, uid, provider)      
    else
      render :text => 'Omniauth is empty :/'
    end  
  end

  def google
    omniauth = request.env['omniauth.auth']
    if omniauth
      omniauth['info']['email'] ? email =  omniauth['info']['email'] : email = ''
      omniauth['info']['name'] ? name =  omniauth['info']['name'] : name = ''
      omniauth['uid'] ? uid =  omniauth['uid'] : uid = ''
      omniauth['provider'] ? provider =  omniauth['provider'] : provider = ''
      connect(name, uid, provider,email)
    else
      render :text => 'Omniauth is empty :/'
    end       
  end

  private

    def connect(name, uid, provider, email = '')
      if uid != '' && provider != ''
        unless user_signed_in?
          auth = Authentification.find_by_uid_and_provider(uid, provider)
          if auth
            flash[:notice] = "Signed in successfully using #{provider}!"
            sign_in_and_redirect(:user, auth.user)
          else
            if email != ''
              existing_user = User.find_by_email(email)
              if existing_user
                existing_user.authentifications.create(:provider => provider, :uid => uid, :uname => name, :uemail => email)
                flash[:notice] = "Sign in via #{provider} has been added to your account #{email}. Signed in successfully!"
              else
                user = User.new :email => email, :password => Devise.friendly_token[0,20]
                user.authentifications.build(:provider => provider, :uid => uid, :uname => name, :uemail => email)
                user.skip_confirmation!
                user.save!
                user.confirm!

                flash[:notice] = "Account created via #{provider}!"
                sign_in_and_redirect(:user, user)
              end
            else
              flash[:error] = 'Unable to sign you up without any email address. Please sign_in with another service'
              redirect_to new_user_session_path
            end
          end
        else
          auth = Authentification.find_by_uid_and_provider(uid, provider)
          if auth
            flash[:notice] = "#{provider} is already linked to your account."
            redirect_to authentifications_path
          else
            current_user.authentifications.create(:provider => provider, :uid => uid, :uname => name, :uemail => email)
            flash[:notice] = "Sign in via #{provider} has been added to your account."
            redirect_to authentifications_path
          end 
        end
      else
        flash[:error] =  authentification_route.capitalize + ' returned invalid data for the user id.'
        redirect_to new_user_session_path
      end
    end
end
