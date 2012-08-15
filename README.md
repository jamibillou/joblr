joblr
=====

Joblr makes looking for work less of a hassle.
You don't have time for resumes and cover letters, companies either.
Joblr profiles are quick to create, share and reply to.
Everybody's time is precious, Joblr helps you make the best of it!


to do
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
- patch LinkedIn API so it supports skill levels


Bugfixes
--------
