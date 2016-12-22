require_relative "lib/bisu/version"

Gem::Specification.new do |s|
  s.name        = 'bisu'
  s.version     = Bisu::VERSION
  s.date        = Bisu::VERSION_UPDATED_AT
  s.summary     = 'A localization automation service'
  s.description = 'Bisu manages your app iOS and Android localization files for you. No more copy+paste induced errors!'
  s.authors     = ['joaoffcosta']
  s.email       = 'joaostacosta@gmail.com'
  s.license     = 'MIT'
  s.homepage    = 'https://github.com/hole19/bisu'

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ['lib']

  s.executables << 'bisu'

  s.add_runtime_dependency 'safe_yaml',  '~> 1.0'
  s.add_runtime_dependency 'colorize',   '~> 0.7'
  s.add_runtime_dependency 'xml-simple', '~> 1.1'
  s.add_runtime_dependency 'onesky-ruby', '~> 1.0'

  s.add_development_dependency 'webmock', '~> 1.20'
end
