class PagesController < ApplicationController

  before_filter :admin_user, only: [:admin, :style_tile]

  def landing
    @title = t('pages.landing.title')
  end

  def admin
    @users           = User.all
    @beta_invites    = BetaInvite.all
  end

  def style_tile
  end
end