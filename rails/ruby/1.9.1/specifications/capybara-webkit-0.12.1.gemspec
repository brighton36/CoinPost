# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "capybara-webkit"
  s.version = "0.12.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["thoughtbot", "Joe Ferris", "Matt Mongeau", "Mike Burns", "Jason Morrison"]
  s.date = "2012-05-30"
  s.email = "support@thoughtbot.com"
  s.extensions = ["extconf.rb"]
  s.files = ["extconf.rb"]
  s.homepage = "http://github.com/thoughtbot/capybara-webkit"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.17"
  s.summary = "Headless Webkit driver for Capybara"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<capybara>, ["< 1.2", ">= 1.0.0"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.6.0"])
      s.add_development_dependency(%q<sinatra>, [">= 0"])
      s.add_development_dependency(%q<mini_magick>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<appraisal>, ["~> 0.4.0"])
    else
      s.add_dependency(%q<capybara>, ["< 1.2", ">= 1.0.0"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.6.0"])
      s.add_dependency(%q<sinatra>, [">= 0"])
      s.add_dependency(%q<mini_magick>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<appraisal>, ["~> 0.4.0"])
    end
  else
    s.add_dependency(%q<capybara>, ["< 1.2", ">= 1.0.0"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.6.0"])
    s.add_dependency(%q<sinatra>, [">= 0"])
    s.add_dependency(%q<mini_magick>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<appraisal>, ["~> 0.4.0"])
  end
end
