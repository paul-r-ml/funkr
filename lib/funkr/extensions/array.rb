require 'funkr/categories'

# Extends array (as list) capabilities
class Array

  include Funkr::Categories

  class << self
    def unit(e); self.new([e]); end
    alias pure unit
    def mzero; self.new(); end
  end

  ### Categories

  # Array is already a functor with its correct map implementation


  # Array can be made an applicative functor, for example :
  #
  #   f = Array.curry_lift_proc{|x,y| x + y}
  #   f.apply([0,4]).apply([5,7]) => [5, 7, 9, 11]
  #   f.apply([0,4]).apply([]) => []
  include Applicative
  extend Applicative::ClassMethods

  def apply(to)
    map do |f|
      to.map{ |t| f.call(t)}
    end.flatten(1)
  end

  # Array is Alternative whith empty? being zero
  include Alternative

  # [].or_else{[5]} => [5]
  def or_else(&block)
    if empty? then yield
    else self end
  end


  # Array is a monoid with mplus = (+) and mzero = []
  include Monoid
  extend Monoid::ClassMethods

  # [5].mplus([6]) => [5,6]
  def mplus(m_y)
    self + m_y
  end


  include Monad
  extend Monad::ClassMethods

  # Array is also a monad
  #
  # [1,2].bind{|x| [3,4].bind{|y| x + y}} # => [4,5,5,6]
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
