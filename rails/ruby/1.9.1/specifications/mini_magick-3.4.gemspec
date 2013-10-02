# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "mini_magick"
  s.version = "3.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Corey Johnson", "Hampton Catlin", "Peter Kieltyka"]
  s.date = "2011-12-28"
  s.description = ""
  s.email = ["probablycorey@gmail.com", "hcatlin@gmail.com", "peter@nulayer.com"]
  s.homepage = "http://github.com/probablycorey/mini_magick"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.17"
  s.summary = "Manipulate images with minimal use of memory via ImageMagick / GraphicsMagick"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<subexec>, ["~> 0.2.1"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<test-unit>, [">= 0"])
    else
      s.add_dependency(%q<subexec>, ["~> 0.2.1"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<test-unit>, [">= 0"])
    end
  else
    s.add_dependency(%q<subexec>, ["~> 0.2.1"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<test-unit>, [">= 0"])
  end
end
