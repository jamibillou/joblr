class ApplicationController < ActionController::Base
  include ApplicationHelper

  protect_from_forgery

  before_filter :set_locale
  before_filter :redirect_to_domain, if: :has_subdomain

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception,                           with: :error_500
    rescue_from ActionController::RoutingError,      with: :error_404
    rescue_from ActionController::UnknownController, with: :error_404
    rescue_from ActionController::UnknownAction,     with: :error_404
    rescue_from ActiveRecord::RecordNotFound,        with: :error_404
  end

  private

    def set_locale
      I18n.default_locale = params[:locale] if !params[:locale].nil?
      I18n.locale = I18n.default_locale
    end

    def redirect_to_domain
      if request.path != '/'
        redirect_to root_url(subdomain: request.subdomain), flash: { error: t('flash.error.subdomain.page') }
      end
    end

    def error_404(exception)
      respond_to do |format|
        format.html {render template: 'errors/error_404', layout: 'layouts/application', status: 404}
        format.all {render nothing: true, status: 404}
      end
    end

    def error_500(exception)
      respond_to do |format|
        format.html {render template: 'errors/error_500', layout: 'layouts/application', status: 500}
        format.all {render nothing: true, status: 500}
      end
    end

    def find_user
      @user = params[:id] ? User.find(params[:id]) : current_user
    end

    def signed_up
      redirect_to(edit_user_path(@user), flash: {error: t('flash.error.only.member')}) unless signed_up?(@user)
    end

    def not_signed_in
      redirect_to root_path, flash: {error: t('flash.error.only.public')} if user_signed_in?
    end

    def redirect_to_back
      redirect_to :back
    rescue ActionController::RedirectBackError
      redirect_to root_path
    end
end
