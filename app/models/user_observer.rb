class UserObserver < ActiveRecord::Observer

  def after_create(user)
    create_subdomain(user)
  end

  private

    def create_subdomain(user)
      user.update_attributes subdomain: user.username
    end
end
