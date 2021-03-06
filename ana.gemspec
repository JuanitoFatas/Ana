# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ana/version'

Gem::Specification.new do |spec|
  spec.name          = 'ana'
  spec.version       = Ana::VERSION::STRING
  spec.authors       = ['Juanito Fatas']
  spec.email         = ['katehuang0320@gmail.com']
  spec.summary       = %q{Ana knows a lot about RubyGems.}
  spec.description   = %q{A command-line tool for https://rubygems.org/}
  spec.homepage      = 'https://github.com/JuanitoFatas/Ana'
  spec.license       = 'MIT'

  spec.files         = %w(bin/ana README.md ana.gemspec LICENSE Rakefile) + Dir.glob('lib/**/*.rb')
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_dependency 'thor',    '~> 0.19.1'
  spec.add_dependency 'launchy', '~> 2.4.2'
  spec.add_dependency 'activesupport', '~> 4.0.1'

  spec.add_development_dependency 'bundler', '>= 1.4'
  spec.add_development_dependency 'rake',    '>= 10.1.0'
end
