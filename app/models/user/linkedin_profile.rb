module User::LinkedinProfile

  def linkedin_profile
    raw_hash = linkedin_client.profile(fields: %w(first_name last_name location positions educations skills))

    { first_name:       raw_hash.first_name,
      last_name:        raw_hash.last_name,
      city:             raw_hash.location.name.split(',').first.gsub(' Area',''),
      country:          raw_hash.location.name.split(',').last,
      current_role:     raw_hash.positions.all.select(&:is_current?).first.title,
      current_company:  raw_hash.positions.all.select(&:is_current?).first.company.name,
      experience:       experience_duration(raw_hash.positions.all),
      education_degree: raw_hash.educations.all.first.degree,
      education_field:  raw_hash.educations.all.first.field_of_study,
      skills:           raw_hash.skills.all.map { |sk| sk.skill.name } }
  end

  def linkedin_client
    auth = auth('linkedin')
    linkedin_client = LinkedIn::Client.new('z9dzn1xi6wkb', '6W2HDTovO9TMOp8U')
    linkedin_client.authorize_from_access(auth.utoken, auth.usecret)
    linkedin_client
  end

  def experience_duration(positions)
    unless positions.nil?
      # fixes nil end_date on current position
      if positions.first.end_date.nil? && positions.first.is_current
        positions.first.end_date = {month: Time.now.month, year: Time.now.year}
      end

      # calculates the different between the first and the last positions
      unless positions.first.end_date.nil? || positions.last.start_date.nil?
        duration = positions.first.end_date.year - positions.last.start_date.year - 1
        unless positions.first.end_date.month.nil? || positions.last.start_date.month.nil?
          duration += (13 - positions.first.end_date.month + positions.last.start_date.month) / 12.0
        end
      end.round
    end
  end
end