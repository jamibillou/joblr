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

Styling
-------

- Finish Devise views (are confirmations and unlocks are used anywhere?)
- migrate to fluid grid
- fix home pages

Features
--------

- *moderate*: build dashboard summarising actions taken by user

Bugfixes
--------

- *high*: handle subdomains on Heroku
- *high*: fix picture uploads on Heroku (they are not stored properly)
- *high*: handle non signed in users (sharings, cookie)
- *high*: send devise emails via postmark, c.f. [Stack overflow](http://stackoverflow.com/questions/5679571/how-can-i-customize-devise-to-send-password-reset-emails-using-postmark-mailer)
- *moderate*: translation keys should be organized by view, DRY doesn't apply to tranlsations
- *moderate*: customise 404/500 pages, c.f. [Heroku documentation](https://devcenter.heroku.com/articles/error-pages) and [Rambling labs](http://ramblinglabs.com/blog/2012/01/rails-3-1-adding-custom-404-and-500-error-pages)
- *low*: patch or pull LinkedIn gem so it supports skill levels
- *low*: patch or pull carrierwave gem so it deletes files properly