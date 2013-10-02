# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "detect_timezone_rails"
  s.version = "0.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Scott Watermasysk"]
  s.date = "2012-03-14"
  s.description = "Simple javascript timezone detection"
  s.email = ["scottwater@gmail.com"]
  s.homepage = "https://rubygems.org/gems/detect_timezone_rails"
  s.require_paths = ["lib"]
  s.rubyforge_project = "detect_timezone_rails"
  s.rubygems_version = "1.8.17"
  s.summary = "Simple javascript timezone detection"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<railties>, ["~> 3.1"])
    else
      s.add_dependency(%q<railties>, ["~> 3.1"])
    end
  else
    s.add_dependency(%q<railties>, ["~> 3.1"])
  end
end
