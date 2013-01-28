if Rails.env.production?
  Honeybadger.configure do |config|
    config.api_key = '0c3be40c'
  end
end
