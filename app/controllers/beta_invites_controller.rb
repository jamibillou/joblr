class BetaInvitesController < ApplicationController

  before_filter :not_signed_in,      except: [:send_code, :destroy]
  before_filter :admin_user,         only:   [:send_code, :destroy]

  def new
    @beta_invite = BetaInvite.new
  end

  def create
    @beta_invite = BetaInvite.new params[:beta_invite]
    unless @beta_invite.save
      flash[:error] = error_messages(@beta_invite)
      render :new
    else
      BetaInviteMailer.notify_team(@beta_invite).deliver
      redirect_to "/beta_invites/#{@beta_invite.id}/thank_you"
    end
  end

  def thank_you
  end

  def send_code
    beta_invite = BetaInvite.find params[:beta_invite_id]
    BetaInviteMailer.send_code(beta_invite).deliver
    beta_invite.update_attributes sent: true
    redirect_to admin_path, :flash => {:success => t('flash.success.beta_invite.email_sent')}
  end

  def edit
    @beta_invite = BetaInvite.find params[:id]
  end

  def update
    if @beta_invite = BetaInvite.find_by_id_and_code(params[:id], params[:beta_invite][:code])
      if !@beta_invite.used?
        session[:beta_invite] = @beta_invite
        redirect_to new_user_registration_path, flash: {success: t('flash.success.beta_invite.used')}
      else
        redirect_to new_beta_invite_path, flash: {error: t('flash.error.beta_invite.used')}
      end
    elsif @beta_invite = BetaInvite.find_by_id(params[:id])
      redirect_to edit_beta_invite_path(@beta_invite), flash: {error: t('flash.error.beta_invite.code_inexistant')}
    end
  end

  def destroy
   BetaInvite.find(params[:id]).destroy
   redirect_to admin_path, :flash => {:success => t('flash.success.beta_invite.destroyed')}
  end
end