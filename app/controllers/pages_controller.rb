class PagesController < ApplicationController

  before_filter :admin_user, only: [:admin, :style_tile]

  def home
    @title = user_signed_in? ? t('pages.overview.title_alt') : t('pages.overview.title')
  end

  def admin
    @users           = User.all
    @beta_invites    = BetaInvite.all
  end

  def style_tile
  end
end