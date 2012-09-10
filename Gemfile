source 'https://rubygems.org'

ruby '1.9.3'
gem 'rails', '3.2.6'
gem 'haml'
gem 'pg'
gem 'jquery-rails'
gem 'rails-i18n'
gem 'devise'
gem 'carrierwave', :git => 'https://github.com/jnicklas/carrierwave.git'
gem 'rmagick'
gem 'omniauth'
gem 'omniauth-linkedin'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'omniauth-twitter'
gem 'linkedin', :git => 'https://github.com/dmatheron/linkedin.git', :branch => '2-0-stable'
gem 'postmark-rails'
gem 'roadie'
gem 'thin' # better web server, more robust on production

group :production, :staging do
  gem 'google-analytics-rails' # View helpers for custom events: https://github.com/bgarret/google-analytics-rails/blob/master/lib/google-analytics/rails/view_helpers.rb
end

group :assets do
  gem 'sass-rails'
  gem 'bootstrap-sass'
  gem 'font-awesome-sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'therubyracer' # Javascript runtime needed for certain features of sass, coffeescript and uglifier to work.
end

group :development do
  gem 'heroku'
  gem 'annotate', '2.4.1.beta1'
  gem 'faker'
  gem 'mail_view', :git => 'https://github.com/37signals/mail_view.git'
end

group :test, :development do
  gem 'rspec-rails'
  gem 'spork'
  gem 'autotest'
  gem 'autotest-growl'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'selenium-webdriver', '2.24'
  gem 'shoulda-matchers'
end
