# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'factlink_blacklist/version'

Gem::Specification.new do |spec|
  spec.name          = "factlink_blacklist"
  spec.version       = FactlinkBlacklist::VERSION
  spec.authors       = ["Mark IJbema", "Eamon Nerbonne"]
  spec.email         = ["markijbema@gmail.com", "eamon@nerbonne.org"]
  spec.summary       = "Generates regular expresions that identify urls where (factlink) annotation is unwanted."
  spec.description   = ""
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0.beta2"
end
