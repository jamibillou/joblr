TO DO
=====

Architecture
------------

- are email sharings and social ones the same?
- rename email sharings into messages
- make sense of social sharings (what should we store?)

Clean up
--------

- remove CONSUMER_KEY and CONSUMER_SECRET from visible code (now in config/initializers/devise.rb)
  c.f: [Heroku documentation](https://devcenter.heroku.com/articles/config-vars) and [Railscast](http://railscasts.com/episodes/235-devise-and-omniauth-revised)

Tests
-----

- test all methods in models
- make AuthentificationsController spec
- check other controller specs
- start creating cucumber features?

Features
--------

- home page: add smooth scrolling between anchors
- make beta private?
- build a dashboard summarizing actions taken by user
- store feedback from LinkedIn API after sharing
- user sharing_id (LinkedIn) to display comments, likes, etc.
- patch LinkedIn API so it supports skill levels


Bugfixes
--------

- email images not displayed in Sparrow.app
- fix error when empty email is submitted in accounts settings
- hide username field in account settings (for users authentificating through social account)