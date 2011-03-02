require 'funkr/adt/adt'
require 'funkr/categories/functor'
require 'funkr/categories/applicative'
require 'funkr/categories/alternative'
require 'funkr/categories/monoid'

module Funkr
  class Maybe < ADT
    
    adt :just, :nothing
    
    include Functor
    
    def map(&block)
      case self.const
      when :just then
        Maybe.just(yield(*self.data))
      else self
      end
    end
    
    include Applicative
    
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
    
    def self.lift_proc(&block)
      Maybe.just(block.curry)
    end
    
    include Alternative
    
    def or_else(&block)
      case self.const
      when :just then self
      else yield
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
      case self.const
      when :just then yield(*self.data)
      else self
      end
    end
    
    
    class << self
      alias unit just
      alias pure just
      alias mzero nothing
    end
    
  end
end
