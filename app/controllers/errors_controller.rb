class ErrorsController < ApplicationController

  def error_404
  	notify_honeybadger(env["action_dispatch.exception"])
  end

  def error_422
  	notify_honeybadger(env["action_dispatch.exception"])
  end

  def error_500
  	notify_honeybadger(env["action_dispatch.exception"])
  end
end
