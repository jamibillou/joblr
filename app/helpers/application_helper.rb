module ApplicationHelper

  def has_subdomain
    request.subdomain.present? && request.subdomain != 'www'
  end

  def signed_up?(user)
    !user.profiles.empty? && user.profile.valid?
  end

  def username_available?(username)
    username if User.find_by_username(username).nil?
  end
end
