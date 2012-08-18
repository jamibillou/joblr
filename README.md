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

- looking into different kinds of sharings (email, social) and solve the mess
- rename sharings into messages
- make sense of social sharings: what should we store?

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

- *hight*: customize Twitter bootstrap
- *moderate*: build dashboard summarising actions taken by user

Bugfixes
--------

- *high*:     handle subdomains on Heroku
- *moderate*: tokens should systematically be organized by views, DRY doesn't apply to tranlsations
- *moderate*: customise error pages, c.f. [Heroku documentation](https://devcenter.heroku.com/articles/error-pages) and [Rambling labs](http://ramblinglabs.com/blog/2012/01/rails-3-1-adding-custom-404-and-500-error-pages)
- *low*:      patch or pull LinkedIn gem so it supports skill levels
- *low*:      patch or pull carrierwave gem so it deletes files properly