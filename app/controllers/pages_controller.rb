class PagesController < ApplicationController

  before_filter :reset_devise_session
  before_filter :admin_user, only: [:admin, :style_tile]

  def home
  end

  def admin
    @users        = User.all
    @beta_invites = BetaInvite.all
  end

  def style_tile
  end
end