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
  end

  def update
  end
end
