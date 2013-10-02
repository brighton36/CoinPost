# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "bootstrap-datepicker-rails"
  s.version = "0.6.14"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Gonzalo Rodr\u{ed}guez-Baltan\u{e1}s D\u{ed}az"]
  s.date = "2012-06-04"
  s.description = "A date picker for Twitter Bootstrap"
  s.email = ["siotopo@gmail.com"]
  s.homepage = "https://github.com/Nerian/bootstrap-datepicker-rails"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.17"
  s.summary = "A date picker for Twitter Bootstrap"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<railties>, [">= 3.0"])
      s.add_development_dependency(%q<bundler>, [">= 1.0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<railties>, [">= 3.0"])
      s.add_dependency(%q<bundler>, [">= 1.0"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<railties>, [">= 3.0"])
    s.add_dependency(%q<bundler>, [">= 1.0"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
