$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "faucet_pipeline_rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name = "faucet_pipeline_rails"
  spec.version = FaucetPipelineRails::VERSION
  spec.authors = ["Lucas Dohmen"]
  spec.email = ["lucas.dohmen@innoq.com"]

  spec.summary = %q(Use Rails with faucet-pipeline)
  spec.description = %q(Instead of using the build-in asset pipeline of Rails, use faucet-pipeline. This gem enables the required integration with Rails.)
  spec.homepage = "https://github.com/faucet-pipeline/faucet_pipeline_rails"
  spec.license = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", ">= 4.2.10"

  spec.add_development_dependency "rubocop", "~> 0.89.1"
  spec.add_development_dependency "rake", "~> 13.0.0"
end
