class PagesController < ApplicationController

  before_filter :admin_user, only: [:admin, :style_tile]

  def landing
    @title = t('pages.landing.title')
  end

  def admin
    @users         = User.all
    @invite_emails = InviteEmail.all
  end

  def style_tile
  end

  def close
  end
end