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
  s.summary     = %q{Functionnal toolbox for Ruby}
  s.description = <<EOF
Funkr is a functionnal toolbox for the Ruby language.

In particular, it offers a simple mechanism to create Algebraïc Data
Types and do pattern matching on them.

It also provide modules for common categories (Monoid, Monad,
Functor, Applicative ...), and extends common types to support
categories they belongs to (Array, Hash ...). Categories can also be
used with custom types,  see provided classes.

Array and Hash classes are extended with methods providing correct
behaviour with respect to categories. Enumerable module comes with
a lot of useful functions for working with lists and sets. See the
module documentation and the test suite for examples.
EOF

  s.rubyforge_project = "funkr"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_development_dependency 'rake', '~> 0.9.2'
end
