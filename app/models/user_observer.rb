class UserObserver < ActiveRecord::Observer

  def after_create(user)
    update_subdomain(user)
  end

  def after_update(user)
    update_subdomain(user) if user.fullname_changed? && user.subdomain.blank?
  end

  private

    def update_subdomain(user)
      user.update_attributes subdomain: build_subdomain(user) unless user.fullname.blank?
    end

    def build_subdomain(user)
      unless subdomain = subdomain_available?(initials(user))
        unless subdomain = subdomain_available?(user.fullname.parameterize)
          subdomain = "user-#{user.id}"
        end
      end
      subdomain
    end

    def subdomain_available?(subdomain)
      subdomain if User.find_by_subdomain(subdomain).nil?
    end

    def initials(user)
      user.fullname.parameterize.split('-').map{ |name| name.chars.first }.join
    end
end
