Gem::Specification.new do |s|
  s.name        = 'bisu'
  s.version     = '1.0.0'
  s.date        = '2015-01-28'
  s.summary     = 'Bisu - localization automation service'
  s.description = 'Bisu is a localization automation service. It was built specially for Hole19'
  s.authors     = ['joaoffcosta']
  s.email       = 'joao.costa@hole19golf.com'
  s.license     = 'MIT'
  s.homepage    = 'https://github.com/hole19/h19-bisu'

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ['lib']

  s.executables << 'bisu'

  s.add_runtime_dependency 'safe_yaml',  '~> 1.0'
  s.add_runtime_dependency 'colorize',   '~> 0.7'
  s.add_runtime_dependency 'xml-simple', '~> 1.1'
  
  s.add_development_dependency 'webmock', '~> 1.20'
end
