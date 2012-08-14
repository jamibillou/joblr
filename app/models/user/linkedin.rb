module User::Linkedin

  def linkedin_attr(attr, linkedin_profile)
    if read_attribute(attr)
      read_attribute(attr)
    elsif profile.read_attribute(attr)
      profile.read_attribute(attr)
    elsif linkedin_profile
      linkedin_profile[attr]
    end
  end
end