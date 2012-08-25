module ProfilesHelper

  def headline_options
    { t('users.show.headline.fulltime')   => 'fulltime',
      t('users.show.headline.partime')    => 'partime',
      t('users.show.headline.internship') => 'internship',
      t('users.show.headline.freelance')  => 'freelance' }
  end
end