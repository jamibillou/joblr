class Subdomain < Struct.new(:value)
  def matches?(request)
    request.subdomain.present? && !%w(www staging joblr joblr-staging).include?(request.subdomain) != 'www' && request.path == '/'
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