module AuthentificationsHelper

  def image_url(type,uid,provider,lk_default=image_path('default_user.jpg'))
    case provider
      when 'twitter'
        if(type == 'thumb')
          "http://api.twitter.com/1/users/profile_image/#{uid}?size=bigger"
        else
          "http://api.twitter.com/1/users/profile_image/#{uid}?size=original"
        end
      when 'linkedin'
      	lk_default
      when 'facebook'
        if(type == 'thumb')
          "http://graph.facebook.com/#{uid}/picture?type=square"
        else
          "http://graph.facebook.com/#{uid}/picture?type=large"
        end
      when 'google_oauth2'
        "https://profiles.google.com/s2/photos/profile/#{uid}"
    end
  end
end
