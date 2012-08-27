class BetaInvitesController < ApplicationController

  before_filter :not_signed_in, except: :index

  def new
    @beta_invite = BetaInvite.new
  end

  def create
    @beta_invite = BetaInvite.new params[:beta_invite]
    unless @beta_invite.save
      redirect_to new_beta_invite_path, flash: { error: error_messages(@beta_invite) }
    else
      BetaInviteMailer.send_beta_invite(@beta_invite).deliver
      redirect_to edit_beta_invite_path(@beta_invite), flash: { success: t('flash.success.beta_invite.sent', email: @beta_invite.email) }
    end
  end

  def edit
    @beta_invite = BetaInvite.find params[:id]
  end

  def update
    if @beta_invite = BetaInvite.find_by_id_and_code(params[:id], params[:beta_invite][:code])
      if @beta_invite.active?
        session[:beta_invite] = @beta_invite
        redirect_to new_user_registration_path, flash: {success: t('flash.success.beta_invite.ok')}
      else
        redirect_to new_beta_invite_path, flash: {error: t('flash.error.beta_invite.inactive')}
      end
    elsif @beta_invite = BetaInvite.find_by_id(params[:id])
      redirect_to edit_beta_invite_path(@beta_invite), flash: {error: t('flash.error.beta_invite.code_inexistant')}
    else
      redirect_to new_beta_invite_path, flash: {error: t('flash.error.something_wrong.base')}
    end
  end
end