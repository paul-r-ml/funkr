# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "funkr/version"

Gem::Specification.new do |s|
  s.name        = "funkr"
  s.version     = Funkr::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Paul Rivier"]
  s.email       = ["paul (dot) r (dot) ml (at) gmail (dot) com"]
  s.homepage    = "http://github.com/paul-r-ml/funkr"
  s.summary     = %q{[EXPERIMENTAL] Some functionnal constructs for ruby}
  s.description = %q{[EXPERIMENTAL] Some functionnal constructs for ruby, like ADT, functors, monads}

  s.rubyforge_project = "funkr"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
