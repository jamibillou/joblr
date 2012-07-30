module AuthentificationsHelper

  def image_url(type,uid,provider)
    case provider
      when 'twitter'
        if(type == 'thumb')
          "http://api.twitter.com/1/users/profile_image/#{uid}?size=bigger"
        else
          "http://api.twitter.com/1/users/profile_image/#{uid}?size=original"
        end
      when 'linkedin'
      	if(type == 'original')
        	auth_hash.info.image
        else
        	image_path('default_user.jpg')
        end
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
