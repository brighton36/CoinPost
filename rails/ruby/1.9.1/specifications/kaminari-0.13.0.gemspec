# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "kaminari"
  s.version = "0.13.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Akira Matsuda"]
  s.date = "2011-12-22"
  s.description = "Kaminari is a Scope & Engine based, clean, powerful, agnostic, customizable and sophisticated paginator for Rails 3"
  s.email = ["ronnie@dio.jp"]
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc"]
  s.homepage = "https://github.com/amatsuda/kaminari"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "kaminari"
  s.rubygems_version = "1.8.17"
  s.summary = "A pagination engine plugin for Rails 3 or other modern frameworks"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 3.0.0"])
      s.add_runtime_dependency(%q<actionpack>, [">= 3.0.0"])
      s.add_runtime_dependency(%q<railties>, [">= 3.0.0"])
      s.add_development_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
      s.add_development_dependency(%q<activerecord>, [">= 3.0.0"])
      s.add_development_dependency(%q<activemodel>, [">= 3.0.0"])
      s.add_development_dependency(%q<sinatra>, [">= 1.3"])
      s.add_development_dependency(%q<mongoid>, [">= 2"])
      s.add_development_dependency(%q<mongo_mapper>, [">= 0.9"])
      s.add_development_dependency(%q<dm-core>, [">= 1.1.0"])
      s.add_development_dependency(%q<dm-migrations>, [">= 1.1.0"])
      s.add_development_dependency(%q<dm-aggregates>, [">= 1.1.0"])
      s.add_development_dependency(%q<dm-sqlite-adapter>, [">= 1.1.0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<rspec-rails>, [">= 0"])
      s.add_development_dependency(%q<rr>, [">= 0"])
      s.add_development_dependency(%q<capybara>, [">= 1.0"])
      s.add_development_dependency(%q<database_cleaner>, [">= 0"])
      s.add_development_dependency(%q<padrino-helpers>, ["~> 0.10"])
      s.add_development_dependency(%q<rack-test>, [">= 0"])
      s.add_development_dependency(%q<sinatra-contrib>, ["~> 1.3"])
      s.add_development_dependency(%q<nokogiri>, [">= 0"])
    else
      s.add_dependency(%q<activesupport>, [">= 3.0.0"])
      s.add_dependency(%q<actionpack>, [">= 3.0.0"])
      s.add_dependency(%q<railties>, [">= 3.0.0"])
      s.add_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
      s.add_dependency(%q<activerecord>, [">= 3.0.0"])
      s.add_dependency(%q<activemodel>, [">= 3.0.0"])
      s.add_dependency(%q<sinatra>, [">= 1.3"])
      s.add_dependency(%q<mongoid>, [">= 2"])
      s.add_dependency(%q<mongo_mapper>, [">= 0.9"])
      s.add_dependency(%q<dm-core>, [">= 1.1.0"])
      s.add_dependency(%q<dm-migrations>, [">= 1.1.0"])
      s.add_dependency(%q<dm-aggregates>, [">= 1.1.0"])
      s.add_dependency(%q<dm-sqlite-adapter>, [">= 1.1.0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<rspec-rails>, [">= 0"])
      s.add_dependency(%q<rr>, [">= 0"])
      s.add_dependency(%q<capybara>, [">= 1.0"])
      s.add_dependency(%q<database_cleaner>, [">= 0"])
      s.add_dependency(%q<padrino-helpers>, ["~> 0.10"])
      s.add_dependency(%q<rack-test>, [">= 0"])
      s.add_dependency(%q<sinatra-contrib>, ["~> 1.3"])
      s.add_dependency(%q<nokogiri>, [">= 0"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 3.0.0"])
    s.add_dependency(%q<actionpack>, [">= 3.0.0"])
    s.add_dependency(%q<railties>, [">= 3.0.0"])
    s.add_dependency(%q<bundler>, [">= 1.0.0"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
    s.add_dependency(%q<activerecord>, [">= 3.0.0"])
    s.add_dependency(%q<activemodel>, [">= 3.0.0"])
    s.add_dependency(%q<sinatra>, [">= 1.3"])
    s.add_dependency(%q<mongoid>, [">= 2"])
    s.add_dependency(%q<mongo_mapper>, [">= 0.9"])
    s.add_dependency(%q<dm-core>, [">= 1.1.0"])
    s.add_dependency(%q<dm-migrations>, [">= 1.1.0"])
    s.add_dependency(%q<dm-aggregates>, [">= 1.1.0"])
    s.add_dependency(%q<dm-sqlite-adapter>, [">= 1.1.0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<rspec-rails>, [">= 0"])
    s.add_dependency(%q<rr>, [">= 0"])
    s.add_dependency(%q<capybara>, [">= 1.0"])
    s.add_dependency(%q<database_cleaner>, [">= 0"])
    s.add_dependency(%q<padrino-helpers>, ["~> 0.10"])
    s.add_dependency(%q<rack-test>, [">= 0"])
    s.add_dependency(%q<sinatra-contrib>, ["~> 1.3"])
    s.add_dependency(%q<nokogiri>, [">= 0"])
  end
end
