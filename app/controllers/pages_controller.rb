class PagesController < ApplicationController

  before_filter :not_signed_in

  def home
  end
end