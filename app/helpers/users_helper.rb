module UsersHelper

  # FIX ME!
  # too many database accesses here, profile and user should be given as arguments
  #
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

  def social_sharing_url(user, provider)
    case provider
      when 'linkedin'
        "http://www.linkedin.com/shareArticle?mini=true&url=#{user.public_url}&title=#{t('users.show.profile emails.title', fullname: user.fullname)}&summary=#{strip_tags t('users.show.public_explanation_html', fullname: user.fullname)}&source=Joblr"
      when 'facebook'
        "https://www.facebook.com/dialog/feed?app_id=419105881446208&link=#{user.public_url}&redirect_uri=#{close_url}&description=#{t('users.show.public_explanation_html', fullname: user.fullname)}&display=popup"
      when 'twitter'
        "http://www.twitter.com/share?url=#{user.public_url}&text=#{t('users.show.profile emails.title', fullname: user.fullname).gsub(' ','+')}"
      when 'google'
        "https://plus.google.com/share?url=#{user.public_url}"
    end
  end

  def social_url_placeholder(provider)
    case provider
      when 'twitter'
        "http://twitter.com/username"
      when 'linkedin'
        "http://linkedin.com/username"
      when 'facebook'
        "http://facebook.com/username"
      when 'google'
        "http://profiles.google.com/username"
    end
  end
end