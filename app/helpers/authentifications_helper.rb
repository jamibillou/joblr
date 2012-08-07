module AuthentificationsHelper

  def username_available?(username)
    username if User.find_by_username(username).nil?
  end

  def image_url(size, uid, provider, default = image_path('default_user.jpg'))
    case provider
      when 'twitter'
        "http://api.twitter.com/1/users/profile_image/#{uid}?size=#{size == 'thumb' ? 'bigger' : 'original'}"
      when 'linkedin'
      	default
      when 'facebook'
        "http://graph.facebook.com/#{uid}/picture?type=#{size == 'thumb' ? 'square' : 'large'}"
      when 'google_oauth2'
        "https://profiles.google.com/s2/photos/profile/#{uid}"
    end
  end
end
