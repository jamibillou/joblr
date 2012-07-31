module AuthentificationsHelper

  def image_url(type, uid, provider, lk_default = image_path('default_user.jpg'))
    case provider
      when 'twitter'
        "http://api.twitter.com/1/users/profile_image/#{uid}?size=#{image_size(type, provider)}"
      when 'linkedin'
      	lk_default
      when 'facebook'
        "http://graph.facebook.com/#{uid}/picture?type=#{image_size(type, provider)}"
      when 'google_oauth2'
        "https://profiles.google.com/s2/photos/profile/#{uid}"
    end
  end

  def image_size(type, provider)
    case provider
      when 'twitter'
        type == 'thumb' ? 'bigger' : 'original'
      when 'facebook'
        type == 'thumb' ? 'square' : 'large'
    end
  end
end
