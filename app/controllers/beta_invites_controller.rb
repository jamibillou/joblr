class BetaInvitesController < ApplicationController

  before_filter :not_signed_in

  def new
    @invite = BetaInvite.new
  end

  def create
    @invite = BetaInvite.new params[:beta_invite]
    unless @invite.save
      redirect_to new_beta_invite_path, flash: { error: error_messages(@invite) }
    else
      BetaInviteMailer.send_invite(@invite).deliver
      redirect_to edit_beta_invite_path(@invite), flash: { success: t('flash.success.invite_sent', email: @invite.email) }
    end
  end

  def edit
    @invite = BetaInvite.find params[:id]
  rescue ActiveRecord::RecordNotFound
    redirect_to new_beta_invite_path, flash: {error: t('flash.error.invite_inexistant')}
  end

  def update
    if @invite = BetaInvite.find_by_id_and_code(params[:id], params[:beta_invite][:code])
      if @invite.active?
        session[:invite] = @invite
        redirect_to new_user_registration_path(invite: @invite), flash: {success: t('flash.success.invite_ok')}
      else
        redirect_to new_beta_invite_path, flash: {error: t('flash.error.invite_used')}
      end
    elsif @invite = BetaInvite.find_by_id(params[:id])
      redirect_to edit_beta_invite_path(@invite), flash: {error: t('flash.error.invite_code_inexistant')}
    else
      redirect_to new_beta_invite_path, flash: {error: t('flash.error.something_wrong')}
    end
  end
end