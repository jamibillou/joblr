module Authentification::Linkedin

  def share(options = {})
    client.share(options)
  end

  def profile
    profile = client.profile(fields: %w(picture_url first_name last_name location positions educations skills))

    { image:      profile.picture_url,
      fullname:   "#{profile.first_name} #{profile.last_name}",
      city:       profile.location.name.split(',').first.gsub(' Area',''),
      country:    profile.location.name.split(',').last,
      role:       profile.positions.select(&:is_current).first.title,
      company:    profile.positions.select(&:is_current).first.company.name,
      experience: experience(profile.positions),
      education:  ("#{profile.educations.first.degree} #{profile.educations.first.field_of_study}" unless profile.educations.blank?),
      skill_1:    (profile.skills[0].name unless profile.skills.blank?),
      skill_2:    (profile.skills[1].name unless profile.skills.blank? || profile.skills.size < 2),
      skill_3:    (profile.skills[2].name unless profile.skills.blank? || profile.skills.size < 3) }
  end

  def experience(positions)
    start_date = { month: positions.last.start_month, year: positions.last.start_year }
    end_date   = positions.first.is_current ? { month: Time.now.month, year: Time.now.year } : { month: positions.first.end_month, year: positions.first.end_year }

    unless end_date[:year] == 0 || start_date[:year] == 0
      duration = end_date[:year] - start_date[:year] - 1
      unless end_date[:month] == 0 || start_date[:month] == 0
        duration += (13 - end_date[:month] + start_date[:month]) / 12.0
      end
      duration.round
    end
  end

  def client
    client = LinkedIn::Client.new('z9dzn1xi6wkb', '6W2HDTovO9TMOp8U')
    client.authorize_from_access(utoken, usecret)
    client
  end
end