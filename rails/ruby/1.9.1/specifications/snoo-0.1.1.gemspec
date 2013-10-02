# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "snoo"
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeff Sandberg"]
  s.date = "2012-12-25"
  s.description = "Snoo is yet another reddit API wrapper. Unlike the other wrappers out there, this one strives to be an almost exact clone of the reddit api, however, it also makes many attempts to be easier to use. You won't be instantiating Snoo::Comment or anything like that. Just one instantiation, and you can do everything from there."
  s.email = ["paradox460@gmail.com"]
  s.homepage = "https://github.com/paradox460/snoo"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9")
  s.rubygems_version = "1.8.17"
  s.summary = "A simple reddit api wrapper"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<httparty>, [">= 0"])
      s.add_runtime_dependency(%q<nokogiri>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<httparty>, [">= 0"])
      s.add_dependency(%q<nokogiri>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<httparty>, [">= 0"])
    s.add_dependency(%q<nokogiri>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
