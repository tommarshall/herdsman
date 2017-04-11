lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)
require 'herdsman/version'

Gem::Specification.new do |spec|
  spec.add_dependency 'thor', '~> 0.19.0'
  spec.authors       = ['Tom Marshall']
  spec.description   =
    'Herdsman is a CLI utility for working with multiple Git repositories'
  spec.files         = %w(herdsman.gemspec) + Dir['*.md',
                                                  'bin/*',
                                                  'lib/**/*.rb']
  spec.email         = 'tommarshall7@gmail.com'
  spec.executables   = ['herdsman']
  spec.homepage      = 'https://github.com/tommarshall/herdsman'
  spec.license       = 'MIT'
  spec.name          = 'herdsman'
  spec.require_paths = ['lib']
  spec.summary       =
    'A CLI utility for working with multiple Git repositories'
  spec.version       = Herdsman::VERSION
end
