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
end