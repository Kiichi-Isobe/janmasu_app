# -*- encoding: utf-8 -*-
# stub: rubystats 0.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "rubystats".freeze
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Ilya Scharrenbroich".freeze, "Bryan Donovan - http://www.bryandonovan.com".freeze, "Phillip Baker".freeze]
  s.date = "2017-12-02"
  s.description = "Ruby Stats is a port of the statistics libraries from PHPMath. Probability distributions include binomial, beta, and normal distributions with PDF, CDF and inverse CDF as well as Fisher's Exact Test.".freeze
  s.homepage = "https://github.com/phillbaker/rubystats".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3".freeze)
  s.rubygems_version = "2.7.6".freeze
  s.summary = "".freeze

  s.installed_by_version = "2.7.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<minitest>.freeze, ["< 5.0", ">= 4.2"])
      s.add_development_dependency(%q<hoe>.freeze, [">= 1.7.0"])
    else
      s.add_dependency(%q<minitest>.freeze, ["< 5.0", ">= 4.2"])
      s.add_dependency(%q<hoe>.freeze, [">= 1.7.0"])
    end
  else
    s.add_dependency(%q<minitest>.freeze, ["< 5.0", ">= 4.2"])
    s.add_dependency(%q<hoe>.freeze, [">= 1.7.0"])
  end
end
