# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "ruby-prof"
  s.version = "0.11.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Shugo Maeda, Charlie Savage, Roger Pack, Stefan Kaes"]
  s.date = "2012-05-06"
  s.description = "ruby-prof is a fast code profiler for Ruby. It is a C extension and\ntherefore is many times faster than the standard Ruby profiler. It\nsupports both flat and graph profiles.  For each method, graph profiles\nshow how long the method ran, which methods called it and which\nmethods it called. RubyProf generate both text and html and can output\nit to standard out or to a file.\n"
  s.email = "shugo@ruby-lang.org, cfis@savagexi.com, rogerdpack@gmail.com, skaes@railsexpress.de"
  s.executables = ["ruby-prof"]
  s.extensions = ["ext/ruby_prof/extconf.rb"]
  s.files = ["bin/ruby-prof", "ext/ruby_prof/extconf.rb"]
  s.homepage = "https://github.com/rdp/ruby-prof"
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7")
  s.rubygems_version = "1.8.17"
  s.summary = "Fast Ruby profiler"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake-compiler>, [">= 0"])
    else
      s.add_dependency(%q<rake-compiler>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake-compiler>, [">= 0"])
  end
end
