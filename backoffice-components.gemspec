Gem::Specification.new do |s|
  s.name        = "backoffice-components"
  s.version     = "0.0.1.2"
  s.summary     = ""
  s.description = "Collection of ViewComponents objects for backoffice"
  s.authors     = ["Julien Camblan"]
  s.email       = "julien@tymate.com"
  s.files       = Dir["{lib}/**/*"]
  s.homepage    =
    "https://rubygems.org/gems/backoffice-components"
  s.license       = "MIT"
  s.require_paths = ['lib']

  s.add_dependency "turbo-rails",        ">= 1.1.1"
  s.add_dependency "stimulus-rails",        ">= 1.1.0"
end