# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "declarative_authorization"
  s.version = "0.5.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Steffen Bartsch"]
  s.date = "2012-01-09"
  s.email = "sbartsch@tzi.org"
  s.extra_rdoc_files = ["README.rdoc", "CHANGELOG"]
  s.files = ["README.rdoc", "CHANGELOG"]
  s.homepage = "http://github.com/stffn/declarative_authorization"
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.6")
  s.rubygems_version = "1.8.17"
  s.summary = "declarative_authorization is a Rails plugin for maintainable authorization based on readable authorization rules."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
