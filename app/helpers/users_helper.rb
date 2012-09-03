module UsersHelper

  def field_value(attribute, linkedin_profile)
    if params[:user] && !params[:user][attribute].blank?
      params[:user][attribute]
    elsif params[:user] && params[:user][:profiles_attributes] && !params[:user][:profiles_attributes]['0'][attribute].blank?
      params[:user][:profiles_attributes]['0'][attribute]
    elsif current_user.read_attribute(attribute)
      current_user.read_attribute(attribute)
    elsif current_user.profile && current_user.profile.read_attribute(attribute)
      current_user.profile.read_attribute(attribute)
    elsif linkedin_profile && linkedin_profile[attribute]
      linkedin_profile[attribute]
    end
  end

  def public_url(user)
    "http://#{user.subdomain}.#{request.domain}"
  end
end