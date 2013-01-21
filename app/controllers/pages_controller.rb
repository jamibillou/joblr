class PagesController < ApplicationController

  before_filter :admin_user,    only: [:admin, :style_tile]
  before_filter :not_signed_in, only: :signup_choice

  def landing
    @version = ab_test('landing_design', 'old', 'new')
    @title   = t("pages.landing.#{@version}.title")
  end

  def admin
    @users            = User.all(order: 'created_at DESC')
    @users_count      = @users.count
    @invite_emails    = InviteEmail.all(order: 'created_at DESC')
    @invites_count    = @invite_emails.count
    @profiles_count   = @users.select{|user| signed_up?(user)}.count
    @activation_count = ProfileEmail.all.select{|pe| pe.profile.user.id == pe.author_id}.map{|pe| pe.author_id}.uniq.count
  end

  def style_tile
  end

  def close
  end

  def signup_choice
    @user = User.new  #TO REMOVE
  end
end