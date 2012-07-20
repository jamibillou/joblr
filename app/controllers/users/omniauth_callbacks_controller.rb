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

  def google_oauth2
    omniauth = request.env['omniauth.auth']
    if omniauth
      omniauth['info']['email'] ? email =  omniauth['info']['email'] : email = ''
      omniauth['info']['name'] ? name =  omniauth['info']['name'] : name = ''
      omniauth['uid'] ? uid =  omniauth['uid'] : uid = ''
      omniauth['provider'] ? provider =  'google' : provider = ''
      connect(name, uid, provider, email)
    else
      render :text => 'Omniauth is empty :/'
    end       
  end

  private

    def connect(name, uid, provider, email = '')
      if uid != '' && provider != ''
        unless user_signed_in?
          auth = Authentification.find_by_uid_and_provider(uid.to_s, provider)
          if auth
            flash[:notice] = "Signed in successfully using #{provider.titleize}!"
            sign_in auth.user
            redirect_to auth.user
          else
            existing_user = User.find_by_email(email)
            if existing_user
              existing_user.authentifications.create(:provider => provider, :uid => uid, :uname => name, :uemail => email)
              flash[:notice] = "You can now sign in with #{provider.titleize} too!"
            else
              user = User.new :fullname => name, :email => email
              user.authentifications.build(:provider => provider, :uid => uid, :uname => name, :uemail => email)
              user.save!
              
              flash[:notice] = "Account created via #{provider.titleize}!"
              sign_in user
              redirect_to user
            end
          end
        else
          auth = Authentification.find_by_uid_and_provider(uid.to_s, provider)
          if auth
            flash[:notice] = "#{provider.titleize} is already linked to your account."
            redirect_to edit_user_registration_path
          else
            current_user.authentifications.create(:provider => provider, :uid => uid, :uname => name, :uemail => email)
            current_user.update_attribute(:email,email) if(email != "" && current_user.email == "") 
            flash[:notice] = "You added your #{provider.titleize} account to your profile."
            redirect_to edit_user_registration_path
          end 
        end
      else
        flash[:error] =  authentification_route.capitalize + ' returned invalid data for the user id.'
        redirect_to new_user_session_path
      end
    end
end
