class ApplicationController < ActionController::Base
  include ApplicationHelper

  protect_from_forgery

  before_filter :set_locale
  before_filter :redirect_to_domain, if: :has_subdomain

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

    def find_user
      @user = params[:id] ? User.find(params[:id]) : current_user
    end

    def not_signed_in
      redirect_back flash: {error: t('flash.error.only.public')} if user_signed_in?
    end

    def signed_up
      redirect_to(edit_user_path(@user), flash: {error: t('flash.error.only.signed_up')}) unless signed_up?(@user) || !user_signed_in?
    end

    def completed_profile
      redirect_back flash: {error: t('flash.error.profile.not_complete')} unless signed_up?(@user) || user_signed_in?
    end

    def admin_user
      redirect_back flash: {error: t('flash.error.only.admin')} unless user_signed_in? && current_user.admin
    end

    def redirect_back(flash = {})
      redirect_to :back, flash
    rescue ActionController::RedirectBackError
      redirect_to root_path, flash
    end

    def never_updated?(object)
      object.created_at == object.updated_at
    end
end
