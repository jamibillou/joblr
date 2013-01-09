class ErrorsController < ApplicationController

	#before_filter: :set_honeybadger_context

  def error_404
  	notify_honeybadger(env["action_dispatch.exception"])
  end

  def error_422
  	notify_honeybadger(env["action_dispatch.exception"])
  end

  def error_500
  	notify_honeybadger(env["action_dispatch.exception"])
  end

  private

  	def set_honeybadger_context
  		Honeybadger.context({id: current_user.id, fullname: current_user.fullname, email: current_user.email}) if user_signed_in?
  	end
end
