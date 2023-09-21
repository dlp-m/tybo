require_relative "lib/tybo/version"

Gem::Specification.new do |spec|
  spec.name        = "tybo"
  spec.version     = Tybo::VERSION
  spec.authors     = ["Michel Delpierre", "Julien Camblan"]
  spec.email       = ["tech@tymate.com"]
  spec.homepage    = "https://rubygems.org/gems/tybo"
  spec.summary       = "A tailwind custom admin engine for Ruby on Rails"
  spec.description   = "Custom admin engine for Ruby on Rails working with generators"
  spec.license     = "MIT"
  spec.metadata["homepage_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency 'rails', '~> 7'
  spec.add_development_dependency 'puma'
  spec.add_dependency 'view_component', '~> 2.82'
  spec.add_dependency 'ransack', '~> 3.2', '>= 3.2.1'
  spec.add_dependency 'pagy', '~> 6.0', '>= 6.0.1'
  spec.add_dependency 'devise', '~> 4.8', '>= 4.8.1'
end
