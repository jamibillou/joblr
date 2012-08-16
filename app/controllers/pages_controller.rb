class PagesController < ApplicationController

  before_filter :not_signed_in

  def home
  end

  def beta
  end

  def get_invited
  end

  private

    def not_signed_in
      redirect_to root_path, flash: {error: t('flash.error.public_only')} if user_signed_in?
    end
end