# Make Split use Redis To Go on Heroku
Split.redis = ENV["REDISTOGO_URL"] if ENV["REDISTOGO_URL"]