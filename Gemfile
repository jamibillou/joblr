source 'https://rubygems.org'

ruby '1.9.3'
gem 'rails', '3.2.11'
gem 'haml'
gem 'pg'
gem 'jquery-rails'
gem 'rails-i18n'
gem 'devise'
gem 'carrierwave'
gem 'fog'
gem 'rmagick'
gem 'omniauth'
gem 'omniauth-linkedin'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'omniauth-twitter'
gem 'linkedin', :git => 'https://github.com/dmatheron/linkedin.git', :branch => '2-0-stable'
gem 'postmark-rails'
gem 'roadie'
gem 'thin'
gem 'mail_view', :git => 'https://github.com/37signals/mail_view.git'
gem 'curb'
gem 'newrelic_rpm'
gem 'honeybadger'
gem 'split'

group :production, :staging do
  gem 'google-analytics-rails'
end

group :development do
  gem 'heroku'
  gem 'annotate'
  gem 'faker'
  gem 'parallel_tests'
end

group :test do
  gem 'rspec-rails'
  gem 'spork'
  gem 'factory_girl_rails'
  gem 'capybara', '1.1.2'
  gem 'capybara-webkit'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '1.3.0'
  gem 'fuubar'
end

group :assets do
  gem 'sass-rails'
  gem 'bootstrap-sass', '2.1.0.0'
  gem 'font-awesome-rails'
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'therubyracer'
end
