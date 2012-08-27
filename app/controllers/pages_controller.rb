class PagesController < ApplicationController

  before_filter :reset_devise_session
  before_filter :admin, only: :style_tile

  def home
    @title = t('pages.overview.title')
  end

  def style_tile
    @title = t('pages.style_tile.title')
  end
end