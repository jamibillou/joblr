CarrierWave.configure do |config|
  if Rails.env.production? || Rails.env.staging?
    config.fog_credentials = {
      # Configuration for Amazon S3
      :provider              => 'AWS',
      :aws_access_key_id     => ENV['AWS_ACCESS_KEY'],
      :aws_secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
      :region                => 'us-east-1'
    }
    config.cache_dir = "#{Rails.root}/tmp/uploads"                  # To let CarrierWave work on heroku

    config.fog_directory    = ENV['S3_BUCKET_NAME']
    config.fog_host         = "//#{ENV['S3_BUCKET_NAME']}.s3.amazonaws.com"
    config.fog_attributes   = {'Cache-Control' => 'max-age=315576000'}
    config.fog_public       = true
    config.storage = :fog
  elsif Rails.env.test?
    config.storage = :file
    config.enable_processing = false
    config.root = "#{Rails.root}/tmp"
  else
    config.storage = :file
    config.enable_processing = false    
  end
end