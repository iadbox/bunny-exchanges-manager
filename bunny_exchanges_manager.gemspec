# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bunny_exchanges/version'

Gem::Specification.new do |spec|
  spec.name          = "bunny_exchanges_manager"
  spec.version       = BunnyExchanges::VERSION
  spec.authors       = ["jcabotc"]
  spec.email         = ["jcabot@gmail.com"]
  spec.summary       = %q{A gem to initialize RabbitMQ exchanges using Bunny on ruby applications}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "bunny"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake"
end
