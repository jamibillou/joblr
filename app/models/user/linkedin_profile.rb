module User::LinkedinProfile

  def linkedin_profile
    linkedin_client(auth('linkedin')).profile
  end

  def linkedin_client(auth)
    linkedin_client = LinkedIn::Client.new('z9dzn1xi6wkb', '6W2HDTovO9TMOp8U')
    linkedin_client.authorize_from_access(auth.utoken, auth.usecret)
    linkedin_client
  end
end