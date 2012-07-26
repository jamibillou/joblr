class ApplicationController < ActionController::Base

  protect_from_forgery

  before_filter :set_locale
  before_filter :redirect_subdomain_requests

  def set_locale
    I18n.default_locale = params[:locale] if !params[:locale].nil?
    I18n.locale = I18n.default_locale
  end

  private

    def redirect_subdomain_requests
      if has_subdomain?(request) && request.path != '/'
        redirect_to root_url(subdomain: false), flash: { error: t('flash.error.not_a_subdomain_page') }
      end
    end

    def has_subdomain?(request)
      request.subdomain.present? && request.subdomain != 'www'
    end

    def subdomain_user(request)
      User.find_by_subdomain! request.subdomain
    rescue ActiveRecord::RecordNotFound
      redirect_to root_url(subdomain: false), flash: { error: t('flash.error.not_a_subdomain') }
    end
end
