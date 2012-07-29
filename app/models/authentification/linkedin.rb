module Authentification::Linkedin

  def linkedin_client
    linkedin_client = LinkedIn::Client.new('z9dzn1xi6wkb', '6W2HDTovO9TMOp8U')
    linkedin_client.authorize_from_access(utoken, usecret)
    linkedin_client
  end
end