# -*- encoding: utf-8 -*-
# stub: mailgun_rails 0.9.0 ruby lib

Gem::Specification.new do |s|
  s.name = "mailgun_rails".freeze
  s.version = "0.9.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jorge Manrubia".freeze]
  s.date = "2017-01-19"
  s.description = "An adapter for using Mailgun with Rails and Action Mailer".freeze
  s.email = ["jorge.manrubia@gmail.com".freeze]
  s.homepage = "https://github.com/jorgemanrubia/mailgun_rails/".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.6".freeze
  s.summary = "Rails Action Mailer adapter for Mailgun".freeze

  s.installed_by_version = "2.7.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<actionmailer>.freeze, [">= 3.2.13"])
      s.add_runtime_dependency(%q<json>.freeze, [">= 1.7.7"])
      s.add_runtime_dependency(%q<rest-client>.freeze, [">= 1.6.7"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 2.14.1"])
      s.add_development_dependency(%q<rails>.freeze, [">= 3.2.13"])
    else
      s.add_dependency(%q<actionmailer>.freeze, [">= 3.2.13"])
      s.add_dependency(%q<json>.freeze, [">= 1.7.7"])
      s.add_dependency(%q<rest-client>.freeze, [">= 1.6.7"])
      s.add_dependency(%q<rspec>.freeze, ["~> 2.14.1"])
      s.add_dependency(%q<rails>.freeze, [">= 3.2.13"])
    end
  else
    s.add_dependency(%q<actionmailer>.freeze, [">= 3.2.13"])
    s.add_dependency(%q<json>.freeze, [">= 1.7.7"])
    s.add_dependency(%q<rest-client>.freeze, [">= 1.6.7"])
    s.add_dependency(%q<rspec>.freeze, ["~> 2.14.1"])
    s.add_dependency(%q<rails>.freeze, [">= 3.2.13"])
  end
end
