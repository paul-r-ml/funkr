# -*- coding: utf-8 -*-
require 'funkr/categories'

# Extends Hash capabilities
class Hash

  # maps function over hash values
  def map_v # &block
    h = Hash.new(self.default)
    self.each{|k,v| h[k] = yield(v)}
    return h
  end

  # maps function over hash keys
  def map_k # &block
    h = Hash.new(self.default)
    self.each{|k,v| h[yield(k)] = v}
    return h
  end

  # maps function over hash keys and values. Block should take
  # 2 parameters, and should return a 2 elements array.
  def map_kv # &block
    h = Hash.new(self.default)
    self.each do |k,v|
      nk, nv = yield(k,v)
      h[nk] = nv
    end
    return h
  end

  include Funkr::Categories

  class << self
    def mzero; self.new(); end
  end

  ### Categories
  
  # Hash is a functor via map_v, but unfortunatly a dumb map method is
  # already defined by the enumerable module, and is kept for
  # compatibility


  # Hash is a monoid if values type is a monoid
  include Monoid
  extend Monoid::ClassMethods
  
  def mplus(m_y)
    self.merge(m_y){|k, v1, v2| v1.mplus(v2)}
  end

end
