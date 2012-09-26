class ApplicationController < ActionController::Base
  include ApplicationHelper

  protect_from_forgery

  before_filter :set_locale
  before_filter :constrain_subdomain_path, if: :subdomain? || :multi_level_subdomain?

  private

    def set_locale
      locale = cookies[:default_locale].nil? && params[:locale].nil? ? get_locale_from_browser : params[:locale]
      cookies[:default_locale] = {value: locale, expires: 15.days.from_now.utc} unless locale.nil?
      I18n.locale = cookies[:default_locale]
    end

    def get_locale_from_browser
      request.env['HTTP_ACCEPT_LANGUAGE'].blank? ? 'en' : request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    end

    def constrain_subdomain_path
      raise ActionController::RoutingError.new(t('errors.routing', path: request.path)) unless request.path.match(/^\/(404|422|500)?$/) || request.xhr?
    end

    def load_user
      unless subdomain?
        @user = params[:id] ? User.find(params[:id]) : current_user
      else
        unless multi_level_subdomain?
          @user = User.find_by_subdomain! request.subdomain
        else
          @user = User.find_by_subdomain! request.subdomains[0]
        end
      end
      @profile = @user.profile
    end

    def not_signed_in
      redirect_to root_path, flash: {error: t('flash.error.only.public')} if user_signed_in?
    end

    def profile_completed
      unless signed_up?(@user)
        if user_signed_in?
          redirect_to edit_user_path(@user), flash: {error: t('flash.error.only.signed_up')}
        else
          raise ActionController::RoutingError.new(t('errors.routing', path: request.path))
        end
      end
    end

    def admin_user
      redirect_to root_path, flash: {error: t('flash.error.only.admin')} unless user_signed_in? && current_user.admin
    end

    def redirect_to_back(flash = {})
      redirect_to :back, flash
    rescue ActionController::RedirectBackError
      redirect_to root_path, flash
    end
end
