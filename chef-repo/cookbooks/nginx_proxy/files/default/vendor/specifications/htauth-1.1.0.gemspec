# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "htauth"
  s.version = "1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeremy Hinegardner"]
  s.date = "2014-03-11"
  s.description = "HTAuth is a pure ruby replacement for the Apache support programs htdigest and htpasswd.  Command line and API access are provided for access to htdigest and htpasswd files."
  s.email = "jeremy@copiousfreetime.org"
  s.executables = ["htdigest-ruby", "htpasswd-ruby"]
  s.extra_rdoc_files = ["CONTRIBUTING.md", "HISTORY.md", "Manifest.txt", "README.md"]
  s.files = ["bin/htdigest-ruby", "bin/htpasswd-ruby", "CONTRIBUTING.md", "HISTORY.md", "Manifest.txt", "README.md"]
  s.homepage = "http://github.com/copiousfreetime/htauth"
  s.licenses = ["ISC"]
  s.rdoc_options = ["--main", "README.md", "--markup", "tomdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.23"
  s.summary = "HTAuth is a pure ruby replacement for the Apache support programs htdigest and htpasswd.  Command line and API access are provided for access to htdigest and htpasswd files."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, ["~> 10.1"])
      s.add_development_dependency(%q<minitest>, ["~> 5.0"])
      s.add_development_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_runtime_dependency(%q<highline>, ["~> 1.6"])
    else
      s.add_dependency(%q<rake>, ["~> 10.1"])
      s.add_dependency(%q<minitest>, ["~> 5.0"])
      s.add_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_dependency(%q<highline>, ["~> 1.6"])
    end
  else
    s.add_dependency(%q<rake>, ["~> 10.1"])
    s.add_dependency(%q<minitest>, ["~> 5.0"])
    s.add_dependency(%q<rdoc>, ["~> 4.0"])
    s.add_dependency(%q<highline>, ["~> 1.6"])
  end
end
