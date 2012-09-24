gem_spec = Gem::Specification.new do |s|
  s.name = 'char_counter'
  s.version = '0.0.1'
  s.date = '2012-09-24'
  s.authors = ['Dominic Matheron', 'Franck Sabattier']
  s.email = 'team@joblr.co'
  s.summary = 'Character counter for textareas'
  s.description = 'Tiny helper that helps adding character counters to your textareas so users know how many characters are allowed.'
  s.files = Dir['app/**/*'] + Dir['lib/**/*'] + Dir['README']
  s.require_paths = ['app', 'lib']
end
