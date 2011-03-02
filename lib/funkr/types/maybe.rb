require 'funkr/adt/adt'
require 'funkr/categories/functor'
require 'funkr/categories/applicative'
require 'funkr/categories/alternative'
require 'funkr/categories/monoid'
require 'funkr/categories/monad'

module Funkr
  class Maybe < ADT

    include Funkr::Categories
    
    adt :just, :nothing
    
    include Functor
    
    def map(&block)
      self.match do |on|
        on.just {|v| Maybe.just(yield(v))}
        on.nothing { self }
      end
    end
    
    include Applicative
    extend Applicative::ClassMethods
    
    def apply(to)
      self.match do |f_on|
        f_on.just do |f|
          to.match do |t_on|
            t_on.just {|t| Maybe.unit(f.call(t)) }
            t_on.nothing { to }
          end
        end
        f_on.nothing { self }
      end
    end
    
    include Alternative
    
    def or_else(&block)
      self.match do |on|
        on.just {|v| self}
        on.nothing { yield }
      end
    end
    
    
    include Monoid
    extend Monoid::ClassMethods
    
    def mplus(m_y)
      self.match do |x_on|
        x_on.nothing { m_y }
        x_on.just do |x|
          m_y.match do |y_on|
            y_on.nothing { self }
            y_on.just {|y| Maybe.just(x.mplus(y))}
          end
        end
      end
    end
    
    
    include Monad
    extend Monad::ClassMethods
    
    def bind(&block)
      self.match do |on|
        on.just {|v| yield(v)}
        on.nothing {self}
      end
    end
    
    
    class << self
      alias unit just
      alias pure just
      alias mzero nothing
    end
    
  end
end
