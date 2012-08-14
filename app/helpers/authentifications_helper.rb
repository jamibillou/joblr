module AuthentificationsHelper

  def auth_hash
    request.env['omniauth.auth']
  end

  def public_url
    case auth_hash.provider
      when 'twitter'
        auth_hash.info.urls.Twitter
      when 'linkedin'
        auth_hash.info.urls.public_profile
      when 'facebook'
        auth_hash.info.urls.Facebook
      when 'google_oauth2'
        auth_hash.extra.raw_info.link
    end
  end

  def auth_secret
    case auth_hash.provider
      when 'linkedin', 'twitter'
        auth_hash.credentials.secret
      when 'facebook', 'google_oauth2'
        ''
    end
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
