joblr
=====

Joblr makes looking for work less of a hassle.
You don't have time for resumes and cover letters, companies either.
Joblr profiles are quick to create, share and reply to.
Everybody's time is precious, Joblr helps you make the best of it!


TO DO
=====

Architecture
------------

- looking into different kinds of sharings (email, social)
- rename sharings into messages
- make sense of social sharings: what do we store?

Clean up
--------

- remove CONSUMER_KEY and CONSUMER_SECRET from config/initializers/devise.rb
  c.f: [Heroku documentation](https://devcenter.heroku.com/articles/config-vars) and [Railscasts](http://railscasts.com/episodes/235-devise-and-omniauth-revised)

Tests
-----

- test all methods in models
- make AuthentificationsController spec
- check other controller specs
- start creating cucumber features

Features
--------

- make beta private
- build dashboard summarizing actions taken by user
- use feedback from LinkedIn API to display comments, likes, etc.


Bugfixes
--------

- customize error pages
- fix "you cannot edit another user's profile" message when trying to add a social profile that already belongs to another user
- fix other flash messages
- change logos and catchphrases in social media dev centers
- hide social profiles (title) from image modal if there is none
- protect public pages access from signed_in users
- add a flash to failed linkedin import (authentification)
- manage subdomains on heroku/gandi
- patch or pull linkedin gem so it supports skill levels
- patch or pull carrierwave gem so it deletes files properly
- handle blank emails better in account settings

  *user_observer.rb*

  ```ruby
  before_update :ignore_blank_email

  private

    def ignore_blank_email
      params[:email] = nil if params[:email].blank
    end
  ```
