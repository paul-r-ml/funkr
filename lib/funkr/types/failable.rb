require 'funkr/adt/adt'
require 'funkr/categories/functor'
require 'funkr/categories/applicative'
require 'funkr/categories/alternative'
require 'funkr/categories/monoid'

module Funkr
  class Failable < ADT
    
    adt :ok, :failed
    
    class << self
      alias unit ok
      alias pure ok
    end
    
    include Functor
    
    def map(&block)
      case self.const
      when :ok then
        Failable.ok(yield(*self.data))
      else self
      end
    end
    
    include Applicative
    
    def apply(to)
      self.match do |f_on|
        f_on.ok do |f|
          to.match do |t_on|
            t_on.ok {|t| Failable.ok(f.call(t)) }
            t_on.failed { to }
          end
        end
        f_on.failed { self }
      end
    end
    
    def self.lift_proc(&block)
      Failable.ok(block.curry)
    end
    
    include Alternative
    
    def or_else(&block)
      case self.const
      when :ok then self
      else yield
      end
    end
    
    
    include Monoid
    extend Monoid::ClassMethods
    
    def mplus(m_y)
      self.match do |x_on|
        x_on.failed { m_y }
        x_on.ok do |x|
          m_y.match do |y_on|
            y_on.failed { self }
            y_on.ok {|y| Failable.ok(x.mplus(y))}
          end
        end
      end
    end
    
    
  end
end
