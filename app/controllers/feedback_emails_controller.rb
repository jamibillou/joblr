class FeedbackEmailsController < ApplicationController

  def create
    @feedback_email = FeedbackEmail.new params[:feedback_email].merge(author: current_user)
    unless @feedback_email.save
      respond_to {|format| format.html { render :json => error_messages(@feedback_email), :status => :unprocessable_entity if request.xhr? }}
    else
      respond_to {|format| format.html { deliver_feedback_email } }
    end
  end

  private

    def deliver_feedback_email
      # FeedbackEmailMailer.footer_form(@feedback_email, current_user).deliver
    end
end
