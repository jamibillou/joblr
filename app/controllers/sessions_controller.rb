class SessionsController < Devise::SessionsController

  before_filter :set_devise_session, only: :new

  private

    def set_devise_session
      session[:devise_controller] = 'sessions'
    end
end