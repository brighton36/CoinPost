# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "foreigner"
  s.version = "1.1.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.5") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matthew Higgins"]
  s.date = "2012-04-04"
  s.description = "Adds helpers to migrations and dumps foreign keys to schema.rb"
  s.email = "developer@matthewhiggins.com"
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc"]
  s.homepage = "http://github.com/matthuhiggins/foreigner"
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7")
  s.rubyforge_project = "foreigner"
  s.rubygems_version = "1.8.17"
  s.summary = "Foreign Keys for Rails"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 3.0.0"])
      s.add_development_dependency(%q<activerecord>, [">= 3.1.0"])
    else
      s.add_dependency(%q<activerecord>, [">= 3.0.0"])
      s.add_dependency(%q<activerecord>, [">= 3.1.0"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 3.0.0"])
    s.add_dependency(%q<activerecord>, [">= 3.1.0"])
  end
end
