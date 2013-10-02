# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "recaptcha"
  s.version = "0.3.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jason L Perry"]
  s.date = "2011-12-13"
  s.description = "This plugin adds helpers for the reCAPTCHA API"
  s.email = ["jasper@ambethia.com"]
  s.homepage = "http://github.com/ambethia/recaptcha"
  s.require_paths = ["lib"]
  s.rubyforge_project = "recaptcha"
  s.rubygems_version = "1.8.17"
  s.summary = "Helpers for the reCAPTCHA API"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<activesupport>, [">= 0"])
      s.add_development_dependency(%q<i18n>, [">= 0"])
    else
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<i18n>, [">= 0"])
    end
  else
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<i18n>, [">= 0"])
  end
end
