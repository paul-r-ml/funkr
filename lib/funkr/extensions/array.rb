require 'funkr/categories'

class Array
  
  include Funkr::Categories
  
  class << self
    def unit(e); self.new([e]); end
    alias pure unit
    def mzero; self.new(); end
  end
  
  ### Categories
  
  # array est déjà un functor via map
  # include Functor 
  
  
  include Applicative
  extend Applicative::ClassMethods
  
  def apply(to)
    map do |f|
      to.map{ |t| f.call(t)}
    end.flatten(1)
  end
  
  include Alternative
  
  def or_else(&block)
    if empty? then yield
    else self end
  end
  
  
  include Monoid
  extend Monoid::ClassMethods
  
  def mplus(m_y)
    self + m_y
  end
  
  
  include Monad
  extend Monad::ClassMethods
  
  def bind(&block)
    self.map(&block).flatten(1)
  end
  
  def self.box(value)
    if value.nil? then self.mzero
    else self.unit(value) end
  end
  
  def unbox()
    if self.empty? then nil
    else self.first end
  end
  
  
end
