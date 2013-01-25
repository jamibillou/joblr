class PagesController < ApplicationController

  before_filter :admin_user,    only: [:admin, :style_tile]
  before_filter :not_signed_in, only: :sign_up

  def landing
    @version = ab_test('landing_design', 'old', 'new')
    @title   = t("pages.landing.#{@version}.title")
  end

  def admin
    @users            = User.all(order: 'created_at DESC')
    @profile_emails   = ProfileEmail.all(order: 'created_at DESC')
    @users_count      = @users.count
    @profiles_count   = @users.select{|user| signed_up?(user)}.count
    @activation_count = @profile_emails.select{|pe| pe.profile.user.id == pe.author_id}.map{|pe| pe.author_id}.uniq.count
  end

  def sign_up
    @user = User.new
  end
end