# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'webook/version'

Gem::Specification.new do |spec|
  spec.name          = "webook"
  spec.version       = Webook::VERSION
  spec.authors       = ["kandayasu"]
  spec.email         = ["yasuhiro.kanda@gmail.com"]
  spec.description   = %q{Write a gem description}
  spec.summary       = %q{Write a gem summary}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "thor"
  spec.add_development_dependency "systemu"
  spec.add_development_dependency "etc"
  spec.add_development_dependency "kramdown"
  spec.add_development_dependency "RedCloth"
end
