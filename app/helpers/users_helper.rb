module UsersHelper

  def username_available?(username)
    username if User.find_by_username(username).nil?
  end

  def initials
    dashed_fullname.split('-').map{ |name| name.chars.first }.join
  end

  def dashed_fullname
    auth_hash.info.name.parameterize
  end

  def build_username
    unless username = username_available?(auth_hash.info.nickname)
      unless username = username_available?(initials)
        unless username = username_available?(dashed_fullname)
          username = "user-#{user.id}"
        end
      end
    end
    username
  end
end
