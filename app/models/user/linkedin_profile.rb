module User::LinkedinProfile

  def linkedin_profile
    raw_hash = linkedin_client.profile(fields: %w(first_name last_name location positions educations skills))
    clean_hash = {
      firstname:       raw_hash.first_name,
      lastname:        raw_hash.last_name,
      city:            raw_hash.location.name.split(',').first.gsub(' Area',''),
      country:         raw_hash.location.name.split(',').last,
      current_role:    raw_hash.positions.all.select(&:is_current?).first.title,
      current_company: raw_hash.positions.all.select(&:is_current?).first.company.name,
      experience:      experience_duration(raw_hash.positions.all),
      experiences:     raw_hash.positions.all.map { |exp| { role: exp.title, company: exp.company.name, current: exp.is_current, desc: exp.summary, start_date: ({ month: exp.start_date.month, year: exp.start_date.year } unless exp.start_date.nil?), end_date: ({ month: exp.end_date.month, year: exp.end_date.year } unless exp.end_date.nil?) } },
      educations:      raw_hash.educations.all.map{ |edu| { degree: edu.degree, field: edu.field_of_study, school: edu.school_name, start_date: ({ month: edu.start_date.month, year: edu.start_date.year } unless edu.start_date.nil?), end_date: ({ month: edu.end_date.month, year: edu.end_date.year } unless edu.end_date.nil?) } },
      skills:          raw_hash.skills.all.map { |sk| sk.skill.name }
    }
    clean_hash
  end

  def linkedin_client
    auth = auth('linkedin')
    linkedin_client = LinkedIn::Client.new('z9dzn1xi6wkb', '6W2HDTovO9TMOp8U')
    linkedin_client.authorize_from_access(auth.utoken, auth.usecret)
    linkedin_client
  end

  def experience_duration(positions)
    unless positions.nil?
      unless positions.first.end_date.nil? || positions.last.start_date.nil?
        duration = positions.first.end_date.year - positions.last.start_date.year - 1
        unless positions.first.end_date.month.nil? || positions.last.start_date.month.nil?
          duration += (13 - positions.first.end_date.month + positions.last.start_date.month) / 12.0
        end
      end
      duration
    end
  end
end