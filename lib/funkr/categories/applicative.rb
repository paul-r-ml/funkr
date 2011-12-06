# -*- coding: utf-8 -*-
module Funkr
  module Categories

    # Functors that can contain a function and be applied to functors
    # containing parameters for the function
    module Applicative

      # Apply the function living inside the functor . The type must be as follow :
      #   Functor(λ(A) : B).apply(Functor(A)) : Functor(B)
      def apply
        raise "Applicative#apply not implemented"
      end

      module ClassMethods
        # Curryfy the lambda block, and lift it into the functor
        def curry_lift_proc(&block)
          self.pure(block.curry)
        end

        # Curryfy the lambda block over N parameter, lifting it to
        # a lambda over N functors
        def full_lift_proc(&block)
          lambda do |*args|
            args.inject(curry_lift_proc(&block)) do |a,e|
              a.apply(e)
            end
          end
        end

        # Lift the block and call parameters on it.
        def lift_with(*args, &block)
          full_lift_proc(&block).call(*args)
        end
      end

      
      def <=>(other)
        proxy_comp(other){|a,b| a <=> b}
      end
       
      def ==(other)
        proxy_comp(other){|a,b| a == b}
      end

      def <(other)
        proxy_comp(other){|a,b| a < b}
      end

      def <=(other)
        proxy_comp(other){|a,b| a <= b}
      end

      def >(other)
        proxy_comp(other){|a,b| a > b}
      end

      def >=(other)
        proxy_comp(other){|a,b| a >= b}
      end


      private

      def proxy_comp(other,&block)
        self.class.
          curry_lift_proc(&block).
          apply(self).apply(other)
      end

    end
  end
end
