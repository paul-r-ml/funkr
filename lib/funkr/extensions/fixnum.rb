require "funkr/categories/monoid"

class Fixnum
  
  include Monoid
  extend Monoid::ClassMethods
  
  def mplus(y)
    self + y
  end
  
end

