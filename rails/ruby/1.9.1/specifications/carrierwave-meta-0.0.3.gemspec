# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "carrierwave-meta"
  s.version = "0.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Victor Sokolov"]
  s.date = "2011-11-11"
  s.description = ""
  s.email = ["gzigzigzi@gmail.com"]
  s.homepage = "http://github.com/gzigzigzeo/carrierwave-meta"
  s.require_paths = ["lib"]
  s.rubyforge_project = "carrierwave-meta"
  s.rubygems_version = "1.8.17"
  s.summary = ""

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<carrierwave>, [">= 0.5.7"])
      s.add_runtime_dependency(%q<activesupport>, [">= 3.0"])
      s.add_runtime_dependency(%q<mime-types>, [">= 0"])
      s.add_development_dependency(%q<rspec-rails>, [">= 2.6"])
      s.add_development_dependency(%q<sqlite3-ruby>, [">= 0"])
      s.add_development_dependency(%q<rmagick>, [">= 0"])
      s.add_development_dependency(%q<mini_magick>, [">= 0"])
      s.add_development_dependency(%q<mime-types>, [">= 0"])
    else
      s.add_dependency(%q<carrierwave>, [">= 0.5.7"])
      s.add_dependency(%q<activesupport>, [">= 3.0"])
      s.add_dependency(%q<mime-types>, [">= 0"])
      s.add_dependency(%q<rspec-rails>, [">= 2.6"])
      s.add_dependency(%q<sqlite3-ruby>, [">= 0"])
      s.add_dependency(%q<rmagick>, [">= 0"])
      s.add_dependency(%q<mini_magick>, [">= 0"])
      s.add_dependency(%q<mime-types>, [">= 0"])
    end
  else
    s.add_dependency(%q<carrierwave>, [">= 0.5.7"])
    s.add_dependency(%q<activesupport>, [">= 3.0"])
    s.add_dependency(%q<mime-types>, [">= 0"])
    s.add_dependency(%q<rspec-rails>, [">= 2.6"])
    s.add_dependency(%q<sqlite3-ruby>, [">= 0"])
    s.add_dependency(%q<rmagick>, [">= 0"])
    s.add_dependency(%q<mini_magick>, [">= 0"])
    s.add_dependency(%q<mime-types>, [">= 0"])
  end
end
