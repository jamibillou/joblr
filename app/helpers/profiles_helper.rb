module ProfilesHelper

  def headline_options
    { t('users.show.headline.fulltime') => 'fulltime',
      t('users.show.headline.partime')  => 'partime',
      t('users.show.internship')        => 'internship',
      t('users.show.freelance')         => 'freelance' }
  end
end