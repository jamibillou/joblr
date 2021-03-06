class Subdomain < Struct.new(:value)
  def matches?(request)
    request.subdomain.present? && request.subdomain != 'www' && !request.host.match(/^staging.joblr.co|joblr.herokuapp.com|joblr-staging.herokuapp.com$/)
  end
end

class MultiLevelSubdomain < Struct.new(:value)
  def matches?(request)
    request.subdomain.present? && request.subdomains.size == 2 && request.host.match(/^[^\.]+\.(staging.joblr.co|joblr.herokuapp.com|joblr-staging.herokuapp.com)$/)
  end
end

class SignedIn < Struct.new(:value)
  def matches?(request)
    !request.session['warden.user.user.key'].nil? == value
  end
end

class SignedUp < Struct.new(:value)
  def matches?(request)
    user = User.find(request.session['warden.user.user.key'][0][0].to_i)
    (!request.session['warden.user.user.key'].nil? && !user.profiles.empty? && user.profile.persisted?) == value
  end
end

class Activated < Struct.new(:value)
  def matches?(request)
    user = User.find(request.session['warden.user.user.key'][0][0].to_i)
    (!request.session['warden.user.user.key'].nil? && user.activated?) == value
  end
end