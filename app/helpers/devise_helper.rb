module DeviseHelper

  def devise_error_messages!
  	flash[:error] = error_messages(resource)
  end
end