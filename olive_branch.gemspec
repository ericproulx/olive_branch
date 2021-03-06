# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('../lib', __FILE__)

require 'olive_branch/version'

Gem::Specification.new do |s|
  s.name        = 'olive_branch'
  s.version     = OliveBranch::VERSION
  s.summary     = 'Handle camel/snake/dash case conversion'
  s.description = 'Handle camel/snake/dash case conversion'
  s.authors     = ['Eli Fatsi', 'David Eisinger']
  s.email       = ['eli.fatsi@viget.com', 'david.eisinger@viget.com']
  s.files       = Dir['lib/**/*'] + ['MIT-LICENSE', 'README.md']
  s.homepage    = 'https://github.com/vigetlabs/olive_branch'
  s.license     = 'MIT'

  s.add_dependency 'actionpack', '>= 4.0'
  s.add_dependency 'activesupport', '>= 4.0'

  s.add_development_dependency 'appraisal'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'simplecov'
end
