# == Schema Information
#
# Table name: authentifications
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  provider   :string(255)
#  uid        :string(255)
#  uname      :string(255)
#  uemail     :string(255)
#  url        :string(255)
#  utoken     :string(255)
#  usecret    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Authentification < ActiveRecord::Base

  include Authentification::Linkedin

  attr_accessible :provider, :uemail, :uid, :uname, :user_id, :url, :utoken, :usecret

  belongs_to :user

  validates :user, :provider, :uid,  presence: true

  def image_url(size = :thumb)
    case provider
      when 'twitter'
        get_redirected_url("http://api.twitter.com/1/users/profile_image/#{uid}").gsub(/_normal/, (size == :thumb ? '_bigger' : ''))
      when 'linkedin'
        profile[:image]
      when 'facebook'
        "http://graph.facebook.com/#{uid}/picture?type=#{size == :thumb ? 'square' : 'large'}"
      when 'google'
        "https://profiles.google.com/s2/photos/profile/#{uid}"
    end
  end

  def get_redirected_url(url)
    result = Curl::Easy.perform(url) do |curl|
      curl.follow_location = true
    end
    result.last_effective_url
  end
end
