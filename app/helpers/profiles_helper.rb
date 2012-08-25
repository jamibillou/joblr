module ProfilesHelper

  def headline_options
    { t('profiles.headline.fulltime')   => 'fulltime',
      t('profiles.headline.partime')    => 'partime',
      t('profiles.headline.internship') => 'internship',
      t('profiles.headline.freelance')  => 'freelance' }
  end
end