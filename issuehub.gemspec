# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'issuehub/version'

Gem::Specification.new do |spec|
  spec.name          = "issuehub"
  spec.version       = Issuehub::VERSION
  spec.authors       = ["meganemura"]
  spec.email         = ["meganemura@users.noreply.github.com"]

  spec.summary       = "Manage filtered GitHub Issues/Pull Requests"
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/meganemura/issuehub"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "dotenv"
  spec.add_runtime_dependency "octokit"

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
