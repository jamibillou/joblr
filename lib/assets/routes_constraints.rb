class HasSubdomain < Struct.new(:value)
  def matches?(request)
    (request.subdomain.present? && request.subdomain != 'www') == value
  end
end

class SignedIn < Struct.new(:value)
  def matches?(request)
    !request.session['warden.user.user.key'].nil? == value
  end
end