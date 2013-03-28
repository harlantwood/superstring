# encoding: UTF-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'superstring/version'

Gem::Specification.new do |gem|
  gem.name          = "superstring"
  gem.version       = Superstring::VERSION
  gem.authors       = ["Harlan T Wood"]
  gem.email         = ["code@harlantwood.net"]
  gem.description   = %q{Grant superpowers to instances of the String class}
  gem.summary       = %q{Split stings into sentences, convert to URL-friendly slugs, generate hashcodes, and more}
  gem.homepage      = "https://github.com/harlantwood/superstring"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'activesupport', '>= 3.0.0'
  gem.add_dependency 'i18n'  
  gem.add_dependency 'addressable'  

  gem.add_development_dependency 'rspec'
end
