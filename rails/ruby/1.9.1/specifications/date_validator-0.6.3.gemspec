# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "date_validator"
  s.version = "0.6.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Oriol Gual", "Josep M. Bach", "Josep Jaume Rey"]
  s.date = "2012-01-22"
  s.description = "A simple, ORM agnostic, Ruby 1.9 compatible date validator for Rails 3, based on ActiveModel. Currently supporting :after, :before, :after_or_equal_to and :before_or_equal_to options."
  s.email = ["info@codegram.com"]
  s.homepage = "http://github.com/codegram/date_validator"
  s.require_paths = ["lib"]
  s.rubyforge_project = "date_validator"
  s.rubygems_version = "1.8.17"
  s.summary = "A simple, ORM agnostic, Ruby 1.9 compatible date validator for Rails 3, based on ActiveModel."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activemodel>, ["~> 3.0"])
      s.add_development_dependency(%q<minitest>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<activesupport>, ["~> 3.0"])
      s.add_development_dependency(%q<tzinfo>, ["~> 0.3.0"])
    else
      s.add_dependency(%q<activemodel>, ["~> 3.0"])
      s.add_dependency(%q<minitest>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<activesupport>, ["~> 3.0"])
      s.add_dependency(%q<tzinfo>, ["~> 0.3.0"])
    end
  else
    s.add_dependency(%q<activemodel>, ["~> 3.0"])
    s.add_dependency(%q<minitest>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<activesupport>, ["~> 3.0"])
    s.add_dependency(%q<tzinfo>, ["~> 0.3.0"])
  end
end
