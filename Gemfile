source 'https://rubygems.org'

ruby '1.9.3'
gem 'rails', '3.2.11'
gem 'pg'
gem 'jquery-rails'
gem 'rails-i18n'
gem 'devise'
gem 'carrierwave'
gem 'fog' # required for AWS
gem 'rmagick'
gem 'omniauth'
gem 'omniauth-linkedin'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'omniauth-twitter'
gem 'linkedin', :git => 'git@github.com:dmatheron/linkedin.git', :branch => '2-0-stable'
gem 'postmark-rails'
gem 'roadie' # adds inline CSS to HTML emails
gem 'thin'   # alternate Web server
gem 'curb'   # URL transfer library (cURL)
gem 'split'

group :production do
  gem 'google-analytics-rails'
  gem 'newrelic_rpm'
  gem 'honeybadger'
end

group :development do
  gem 'heroku'
  gem 'mail_view', :git => 'https://github.com/37signals/mail_view.git'
  gem 'faker'
end

group :test do
  gem 'spork'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'capybara', '1.1.2'
  gem 'capybara-webkit'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '1.3.0'
  gem 'annotate'
  gem 'fuubar'
  gem 'guard'
  gem 'rb-inotify', :require => false
  gem 'rb-fsevent', :require => false
  gem 'rb-fchange', :require => false
  gem 'growl'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'guard-pow'
end

group :assets do
  gem 'haml'
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'bootstrap-sass', '2.1.0.0'
  gem 'font-awesome-rails'
end
