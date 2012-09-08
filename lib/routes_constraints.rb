class Subdomain < Struct.new(:value)
  def matches?(request)
    request.subdomain.present? && request.subdomain != 'www' && !%w(staging.joblr.co joblr.herokuapp.com joblr-staging.herokuapp.com).include?("#{request.subdomain}.#{request.host}")
  end
end

class SignedIn < Struct.new(:value)
  def matches?(request)
    !request.session['warden.user.user.key'].nil? == value
  end
end

class SignedUp < Struct.new(:value)
  def matches?(request)
    user = User.find(request.session['warden.user.user.key'][1][0].to_i)
    (!request.session['warden.user.user.key'].nil? && !user.profiles.empty? && user.profile.valid?) == value
  end
end