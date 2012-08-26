class PagesController < ApplicationController

  before_filter :not_signed_in
  before_filter :reset_devise_session

  def home
  end
end