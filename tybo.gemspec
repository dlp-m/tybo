require_relative "lib/tybo/version"

Gem::Specification.new do |spec|
  spec.name        = "tybo"
  spec.version     = Tybo::VERSION
  spec.authors     = ["dlp-m"]
  spec.email       = ["michel@tymate.com"]
  spec.homepage    = "https://rubygems.org/gems/ty-bo-generator"
  spec.summary     = "summary of Blorgh."
  spec.description = "Description of Blorgh."
  spec.license     = "MIT"
  
  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
#   spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.4.1"
  spec.add_development_dependency "puma"
  spec.add_development_dependency "importmap-rails"
  spec.add_dependency 'view_component'
  spec.add_dependency 'tailwindcss-rails'
  spec.add_dependency 'simple_form'
  spec.add_dependency 'simple_form-tailwind'
  spec.add_dependency 'ransack'
  spec.add_dependency 'pagy'
  spec.add_dependency 'devise'
end
