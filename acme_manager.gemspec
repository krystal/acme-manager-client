# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'acme_manager/version'

Gem::Specification.new do |spec|
  spec.name          = "acme_manager"
  spec.version       = AcmeManager::VERSION
  spec.authors       = ["Dan Wentworth"]
  spec.email         = ["dan@atechmedia.com"]

  spec.summary       = "Client library for the acme-manager server"
  spec.description   = "Provides a client library for interacting with the acme-manager server
    (https://github.com/catphish/acme-manager) which assists with issuing lets-encrypt certificates"
  spec.homepage      = "https://github.com/darkphnx/acme-manager-client"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
