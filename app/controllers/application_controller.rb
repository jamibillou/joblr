class ApplicationController < ActionController::Base
  include ApplicationHelper

  protect_from_forgery

  before_filter :set_locale
  before_filter :redirect_to_domain, if: :has_subdomain

  def set_locale
    I18n.default_locale = params[:locale] if !params[:locale].nil?
    I18n.locale = I18n.default_locale
  end

  private

    def redirect_to_domain
      if request.path != '/'
        redirect_to root_url(subdomain: request.subdomain), flash: { error: t('flash.error.subdomain.page_doesnt_exist') }
      end
    end
end
