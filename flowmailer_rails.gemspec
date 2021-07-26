lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "flowmailer_rails/version"

Gem::Specification.new do |spec|
  spec.name = "flowmailer_rails"
  spec.version = FlowmailerRails::VERSION
  spec.authors = ["Jonas Brusman"]
  spec.email = ["jonas@teamtailor.com"]

  spec.summary = "ActionMailer adapter for Flowmailer"
  spec.description = "Send ActionMailer messages with the Flowmailer API"
  spec.homepage = "https://github.com/Teamtailor/flowmailer_rails"
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Teamtailor/flowmailer_rails"
  spec.metadata["changelog_uri"] = "https://github.com/Teamtailor/flowmailer_rails/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) || f.start_with?(".") }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency("actionmailer", ">= 3.0.0")
  spec.add_dependency("faraday", ">= 0.7.4")
  spec.add_dependency("faraday_middleware")

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-json_expectations", "~> 2.2"
  spec.add_development_dependency "simplecov", "~> 0.19"
  spec.add_development_dependency "webmock", "~> 3.10.0"
  spec.add_development_dependency "standard", "~> 0.6.1"
end
