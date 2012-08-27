class PagesController < ApplicationController

  before_filter :not_signed_in
  before_filter :reset_devise_session

  def home
    @title = t('pages.overview.title')
  end

  def style_tile
    @title = t('pages.style_tile.title')
  end
end