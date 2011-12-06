# -*- coding: utf-8 -*-
require 'funkr/adt/adt'
require 'funkr/categories'

module Funkr
  module Types

    # Algebraïc Data Type representing the possibility of a missing
    # value : nothing. It cleanly replace the 'nil' paradigm often
    # found in ruby code, and often leading to bugs. The Maybe type
    # belongs to multiple categories, making it extremly expressive to
    # use (functor, applicative, alternative, monad, monoid ... !).
    #
    # You will get maximum performance and maximum expressiveness if
    # you can use provided high level functions (map, apply, or_else,
    # ...) instead of pattern-matching yourself.
    class Maybe < ADT

      include Funkr::Categories

      adt :just, :nothing

      ### Categories

      include Functor
      
      # {Funkr::Categories::Functor#map see functor map}
      #
      #   Maybe.nothing.map{|x| something(x)} # => nothing
      #   Maybe.just(x).map{|x| something(x)} # => just something(x)
      def map(&block)
        # This implementation isn't safe but is a bit faster than the
        # safe one. A safe implementation would be as follow :
        #   self.match do |on|
        #     on.just {|v| self.class.just(yield(v))}
        #     on.nothing { self }
        #   end
        if self.just? then self.class.just(yield(unsafe_content))
        else self end
      end

      include Applicative
      extend Applicative::ClassMethods

      # {Funkr::Categories::Applicative#apply see applicative apply}
      #
      # Maybe can be made an applicative functor, for example :
      #   f = Maybe.curry_lift_proc{|x,y| x + y}
      #   a = Maybe.just(3)
      #   b = Maybe.just(4)
      #   c = Maybe.nothing
      #   f.apply(a).apply(b) => Just 7
      #   f.apply(a).apply(c) => Nothing
      def apply(to)
        # This implementation isn't safe but is a bit faster than the
        # safe one. A safe implementation would be as follow :
        #   self.match do |f_on|
        #     f_on.just do |f|
        #       to.match do |t_on|
        #         t_on.just {|t| self.class.unit(f.call(t)) }
        #         t_on.nothing { to }
        #       end
        #     end
        #     f_on.nothing { self }
        #   end
        if self.just? and to.just? then
          self.class.unit(self.unsafe_content.call(to.unsafe_content))
        else self.class.nothing end
      end

      include Alternative

      # {Funkr::Categories::Alternative#or_else see alternative or_else}
      def or_else(&block)
        self.match do |on|
          on.just {|v| self}
          on.nothing { yield }
        end
      end


      include Monoid
      extend Monoid::ClassMethods

      # {Funkr::Categories::Monoid#mplus see monoid mplus}
      def mplus(m_y)
        self.match do |x_on|
          x_on.nothing { m_y }
          x_on.just do |x|
            m_y.match do |y_on|
              y_on.nothing { self }
              y_on.just {|y| self.class.just(x.mplus(y))}
            end
          end
        end
      end


      include Monad
      extend Monad::ClassMethods

      # {Funkr::Categories::Monad#bind see monad bind}
      def bind(&block)
        # This implementation isn't safe but is a bit faster than the
        # safe one. A safe implementation would be as follow :
        #   self.match do |on|
        #     on.just {|v| yield(v)}
        #     on.nothing {self}
        #   end
        if self.just? then yield(self.unsafe_content)
        else self end
      end

      # Unbox a maybe value. You must provide a default in case of
      # nothing. This method is not as safe as the others, as it will
      # escape the content from the Maybe type safety.
      #
      # Maybe.just(5).unbox(:foobar) # => 5
      # Maybe.nothing.unbox(:foobar) # => :foobar
      def unbox(default=nil)
        self.match do |on|
          on.just {|v| v }
          on.nothing { default }
        end
      end

      class << self
        alias unit just
        alias pure just
        alias mzero nothing
      end

      # unsafe access to content, for performance purpose only
      def unsafe_content; self.unsafe_data.first; end

      # Box nil as nothing, and the rest as just x
      def self.box(value)
        if value.nil? then self.nothing
        else self.just(value) end
      end

      # concat :: [Maybe a] -> [a]
      #  The Maybe.concat function takes a list of Maybes and returns
      #  a list of all the Just values.
      def self.concat(maybes)
        maybes.inject([]) do |a, e|
          e.match do |on|
            on.just{|v| a + [v]}
            on.nothing{ a }
          end
        end
      end

    end
  end
end
