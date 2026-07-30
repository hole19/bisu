require_relative "lib/bisu/version"

Gem::Specification.new do |s|
  s.name        = 'bisu'
  s.version     = Bisu::VERSION
  s.summary     = 'A localization automation service'
  s.description = "Bisu manages your app's iOS and Android localization files for you. No more copy+paste induced errors!"
  s.authors     = ['joaoffcosta']
  s.email       = 'joaostacosta@gmail.com'
  s.license     = 'MIT'
  s.homepage    = 'https://github.com/hole19/bisu'

  s.metadata = {
    'source_code_uri'       => 'https://github.com/hole19/bisu',
    'changelog_uri'         => 'https://github.com/hole19/bisu/blob/main/CHANGELOG.md',
    'bug_tracker_uri'       => 'https://github.com/hole19/bisu/issues',
    'rubygems_mfa_required' => 'true',
  }

  s.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{\A(?:spec|\.github)/}) ||
      f.match(%r{\A\.(?:travis\.yml|rspec)\z}) ||
      %w[README_explanation.png Gemfile.lock].include?(f)
  end
  s.require_paths = ['lib']
  s.executables = %w[ bisu ]

  s.required_ruby_version = '>= 3.0.0'

  s.add_dependency 'colorize', '~> 1.1'
  s.add_dependency 'csv', '>= 3.0'                 # For Google Sheets interpretation
  s.add_dependency 'rubyzip', '>= 2.0.0', '< 4.0'  # For extracting the Tolgee zip file
end
