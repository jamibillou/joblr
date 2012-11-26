class PagesController < ApplicationController

  before_filter :admin_user, only: [:admin, :style_tile]

  def landing
    @title = t('pages.landing.title')
  end

  def admin
    @users           = User.all
    @beta_invites    = BetaInvite.all
  end

  def search
    @title = 'Search'
  end

  def search2
    @title = 'Search'
  end

  def search3
    @title = 'Search'
  end

  def search4
    @title = 'Search'
  end

  def search5
    @title = 'Search'
  end

  def search6
    @title = 'Search'
  end
end