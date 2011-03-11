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
  
  
  # other extensions
  class NoHead; end
  
  def head; empty? ? NoHead : first; end
  
  def tail; size > 1 ? self[1..-1] : []; end
  
  def all_different?
    return true if tail.empty?
    !tail.include?(head) and tail.all_different?
  end
  
  # http://www.haskell.org/ghc/docs/6.12.2/html/libraries/base-4.2.0.1/src/Data-List.html#group
  def group_seq_by(&block)
    if empty? then []
    else
      a,b = tail.span{|x| (yield head) == (yield x)}
      [a.unshift(head)] + b.group_seq_by(&block)
    end
  end
  
  # http://www.haskell.org/ghc/docs/6.12.2/html/libraries/base-4.2.0.1/src/GHC-List.html#span
  def span(&block)
    if empty? then [[],[]]
    elsif (yield head) then
      a,b = tail.span(&block)
      [a.unshift(head),b]
    else [[], self]
    end
  end

  # Constitue des groupes de n éléments
  def groups_of(ar, n)
    return [] if self.empty?
    [self.take(n)] + groups_of(self.drop(n), n)
  end

  
end
