require "funkr/categories/monoid"

class Integer

  include Funkr::Categories
  
  include Monoid
  extend Monoid::ClassMethods
  
  def mplus(y)
    self + y
  end

  def self.mzero
    0
  end
  
end
