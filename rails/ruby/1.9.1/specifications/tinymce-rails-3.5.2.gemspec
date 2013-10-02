# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "tinymce-rails"
  s.version = "3.5.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sam Pohlenz"]
  s.date = "2012-06-08"
  s.description = "Seamlessly integrates TinyMCE into the Rails asset pipeline introduced in Rails 3.1."
  s.email = "sam@sampohlenz.com"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.17"
  s.summary = "Rails asset pipeline integration for TinyMCE."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<railties>, [">= 3.1.1"])
    else
      s.add_dependency(%q<railties>, [">= 3.1.1"])
    end
  else
    s.add_dependency(%q<railties>, [">= 3.1.1"])
  end
end
