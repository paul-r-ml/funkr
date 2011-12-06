# -*- coding: utf-8 -*-
if RUBY_VERSION.split(".")[0..1] == ["1","8"] then
  require 'funkr/compat/1.8'
end

# Funkr brings some common functional programming constructs to ruby.
#
# In particular, it offers a simple mechanism to create Algebraïc Data
# Types and do pattern matching on them. For an exemple
# implementation, {Funkr::Types see provided classes}.
#
# It also provide modules for common categories (Monoid, Monad,
# Functor, Applicative ...), and extends common types to support
# categories they belongs to (Array, Hash ...). Categories can also be
# used with custom types, {Funkr::Types see provided classes}.
module Funkr
  
end
