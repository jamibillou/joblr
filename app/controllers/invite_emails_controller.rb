class InviteEmailsController < ApplicationController

  before_filter :not_signed_in,      except: [:send_code, :destroy]
  before_filter :admin_user,         only:   [:send_code, :destroy]

  def new
    @invite_email = InviteEmail.new
  end

  def create
    @invite_email = InviteEmail.new params[:invite_email]
    unless @invite_email.save
      flash[:error] = error_messages(@invite_email)
      render :new
    else
      InviteEmailMailer.notify_team(@invite_email).deliver
      redirect_to "/invite_emails/#{@invite_email.id}/thank_you"
    end
  end

  def thank_you
  end

  def send_code
    invite_email = InviteEmail.find params[:invite_email_id]
    InviteEmailMailer.send_code(invite_email).deliver
    invite_email.update_attributes sent: true
    redirect_to admin_path, :flash => {:success => t('flash.success.invite_email.email_sent')}
  end

  def edit
    @invite_email = InviteEmail.find params[:id]
  end

  def update
    if @invite_email = InviteEmail.find_by_id_and_code(params[:id], params[:invite_email][:code])
      if !@invite_email.used?
        session[:invite_email] = @invite_email
        redirect_to new_user_registration_path, flash: {success: t('flash.success.invite_email.used')}
      else
        redirect_to new_invite_email_path, flash: {error: t('flash.error.invite_email.used')}
      end
    elsif @invite_email = InviteEmail.find_by_id(params[:id])
      redirect_to edit_invite_email_path(@invite_email), flash: {error: t('flash.error.invite_email.code_inexistant')}
    end
  end

  def destroy
   InviteEmail.find(params[:id]).destroy
   redirect_to admin_path, :flash => {:success => t('flash.success.invite_email.destroyed')}
  end
end