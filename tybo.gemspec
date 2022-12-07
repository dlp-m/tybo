Gem::Specification.new do |s|
  s.name        = "tybo"
  s.version     = "0.0.3"
  s.summary     = ""
  s.description = "Collection of ViewComponents objects for backoffice"
  s.authors     = ["Julien Camblan", "Michel Delpierre"]
  s.email       = "tech@tymate.com"
  s.files       = Dir["{lib}/**/*"]
  s.homepage    =
    "https://rubygems.org/gems/backoffice-components"
  s.license       = "MIT"
  s.require_paths = ['lib']

  s.add_dependency "turbo-rails", ">= 1.1.1"
  s.add_dependency "stimulus-rails", ">= 1.1.0"
  s.add_dependency "view_component", ">= 2.62.0"
  s.add_dependency "tailwindcss-rails", "~> 2.0"
  s.add_dependency "ransack"
end