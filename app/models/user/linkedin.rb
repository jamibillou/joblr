module User::Linkedin

  def update_linkedin_status(status)
    linkedin_client.update_status(status)
  end

  def linkedin_attribute(attribute, linkedin_profile)
    if read_attribute(attribute)
      read_attribute(attribute)
    elsif profile.read_attribute(attribute)
      profile.read_attribute(attribute)
    elsif linkedin_profile
      linkedin_profile[attribute]
    end
  end

  def linkedin_profile
    hash = linkedin_hash

    { fullname:   "#{hash.first_name} #{hash.last_name}",
      city:       hash.location.name.split(',').first.gsub(' Area',''),
      country:    hash.location.name.split(',').last,
      role:       hash.positions.all.select(&:is_current?).first.title,
      company:    hash.positions.all.select(&:is_current?).first.company.name,
      experience: experience_duration(hash.positions.all),
      education:  ("#{hash.educations.all.first.degree} #{hash.educations.all.first.field_of_study}" unless hash.educations.total == 0),
      skill_1:    (hash.skills.all[0].skill.name unless hash.skills.nil?),
      skill_2:    (hash.skills.all[1].skill.name unless hash.skills.nil? || hash.skills.all.size < 2),
      skill_3:    (hash.skills.all[2].skill.name unless hash.skills.nil? || hash.skills.all.size < 3) }
  end

  def linkedin_hash
    linkedin_client.profile(fields: %w(first_name last_name location positions educations skills))
  end

  def experience_duration(positions)
    # fixes nil end_date on current position
    if positions.first.start_date && positions.first.end_date.nil? && positions.first.is_current
      positions.first.end_date = {month: Time.now.month, year: Time.now.year}
    end

    # calculates the duration between the first and the last positions
    unless positions.first.end_date.nil? || positions.last.start_date.nil?
      duration = positions.first.end_date.year - positions.last.start_date.year - 1
      unless positions.first.end_date.month.nil? || positions.last.start_date.month.nil?
        duration += (13 - positions.first.end_date.month + positions.last.start_date.month) / 12.0
      end
      duration.round
    end
  end

  def linkedin_client
    auth = auth('linkedin')
    linkedin_client = LinkedIn::Client.new('z9dzn1xi6wkb', '6W2HDTovO9TMOp8U')
    linkedin_client.authorize_from_access(auth.utoken, auth.usecret)
    linkedin_client
  end
end