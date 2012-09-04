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

  def social_sharing_url(user,network)
    case network
      when 'linkedin'
        "http://www.linkedin.com/shareArticle?mini=true&url=#{user.public_url}&title=#{t('users.show.sharings.title', fullname: user.fullname)}&summary=#{t('users.show.sharings.motto')}&source=Joblr"
      when 'facebook'
        "http://www.facebook.com/sharer.php?u=#{user.public_url}"
      when 'twitter'
        "http://www.twitter.com/share?url=#{user.public_url}&text=#{t('users.show.sharings.title', fullname: user.fullname).gsub(' ','+')}"
      when 'google'
        "https://plus.google.com/share?url=#{user.public_url}"
    end
  end
end