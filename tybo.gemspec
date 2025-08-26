require_relative "lib/tybo/version"

Gem::Specification.new do |spec|
  spec.name        = "tybo"
  spec.version     = Tybo::VERSION
  spec.authors     = ["Michel Delpierre", "Julien Camblan"]
  spec.email       = ["michel@tymate.com"]
  spec.homepage    = "https://rubygems.org/gems/tybo"
  spec.summary       = "A tailwind custom admin engine for Ruby on Rails"
  spec.description   = "Custom admin engine for Ruby on Rails working with generators"
  spec.license     = "MIT"
  spec.metadata["homepage_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.0"
  spec.add_development_dependency 'puma'
  spec.add_dependency 'view_component', '>= 3.11.0'
  spec.add_dependency 'ransack', '~> 4.1'
  spec.add_dependency 'pagy', '~> 7.0'
  spec.add_dependency 'devise', '~> 4.9'
  spec.add_dependency 'action_policy', '~> 0.7.5'
  spec.add_dependency 'tailwindcss-rails', '~> 3'
end
