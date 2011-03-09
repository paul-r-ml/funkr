require "funkr/categories/monoid"

class Fixnum

  include Funkr::Categories
  
  include Monoid
  extend Monoid::ClassMethods
  
  def mplus(y)
    self + y
  end
  
end

