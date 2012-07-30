module User::LinkedinProfile

  def linkedin_profile
    client = linkedin_client
    client.profile(fields: %w(first_name last_name location positions educations skills))

    # Produces a nicely formatted hash but take 9 to 10s to execute,
    # too many API calls in a row.
    #
    # {
    #   fullname: "#{client.profile(fields: %w(first_name)).first_name} #{client.profile(fields: %w(last_name)).last_name}",
    #   city:        client.profile(fields: %w(location)).location.name.split(',').first.gsub(' Area',''),
    #   country:     client.profile(fields: %w(location)).location.name.split(',').last,
    #   role:        client.profile(fields: %w(positions)).positions.all.select(&:is_current?).first.title,
    #   company:     client.profile(fields: %w(positions)).positions.all.select(&:is_current?).first.company.name,
    #   education:   "#{client.profile(fields: %w(educations)).educations.all.first.degree}, #{client.profile(fields: %w(educations)).educations.all.first.field_of_study}",
    #   skill_1:     client.profile(fields: %w(skills)).skills.all[0].skill.name,
    #   skill_2:     client.profile(fields: %w(skills)).skills.all[1].skill.name,
    #   skill_3:     client.profile(fields: %w(skills)).skills.all[2].skill.name
    # }
  end

  def linkedin_attribute(attribute, client)
    client.profile(fields: [attribute])
  end

  def linkedin_client
    auth = auth('linkedin')
    linkedin_client = LinkedIn::Client.new('z9dzn1xi6wkb', '6W2HDTovO9TMOp8U')
    linkedin_client.authorize_from_access(auth.utoken, auth.usecret)
    linkedin_client
  end
end