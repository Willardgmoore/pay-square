$LOAD_PATH.push File.expand_path("lib", __dir__)

require "pay/square/version"

Gem::Specification.new do |spec|
  spec.name = "pay-square"
  spec.version = Pay::Square::VERSION
  spec.authors = ["Willard Moore"]
  spec.email = ["willardgmoore@gmail.com"]

  spec.summary = "Square payment processor for the Pay gem"
  spec.description = "Adds a Square payment processor to Pay. Charge on a merchant's own connected Square account (per-merchant OAuth), with card-on-file, refunds, application fees, and webhooks."
  spec.homepage = "https://github.com/Willardgmoore/pay-square"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir[
    "{app,config,db,lib}/**/*",
    "MIT-LICENSE",
    "Rakefile",
    "README.md",
    "CHANGELOG.md"
  ]
  spec.require_paths = ["lib"]

  spec.add_dependency "pay", ">= 11.0"
  spec.add_dependency "square.rb", "~> 44"
end
