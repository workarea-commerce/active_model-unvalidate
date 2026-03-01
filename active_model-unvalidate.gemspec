lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "active_model/unvalidate/version"

Gem::Specification.new do |spec|
  spec.name          = "active_model-unvalidate"
  spec.version       = ActiveModel::Unvalidate::VERSION
  spec.authors       = ["Matt Duffy"]
  spec.email         = ["mduffy@weblinc.com"]

  spec.summary       = %q{Provides an ActiveModel::Unvalidate module to remove validations}
  spec.description   = %q{ActiveModel::Unvalidate provides a clean api for removing existing validations from models}
  spec.homepage      = "https://github.com/weblinc/active_model-unvalidate"
  spec.license       = "MIT"

  spec.required_ruby_version = [">= 2.7", "< 3.5"]

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activemodel", ">= 6.0"
  spec.add_dependency "activesupport", ">= 6.0"

  spec.add_development_dependency "bundler", ">= 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
