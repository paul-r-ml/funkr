# -*- coding: utf-8 -*-
module Funkr
  module Categories
    
    # A functor can also be made an instance of Monad if you can
    # define a bind operation on it. The bind operation must follow
    # the monads laws :
    #  - Functor.unit(x).bind(f) == f.call(X)
    #  - monad.bind{|x| Functor.unit(x)} == monad
    #  - monad.bind{|x| f(monad).bind(g)} == monad.bind{|x| f(x)}.bind{|x| g(x)}
    #
    # Usually you will want your type to be a monad if you need to
    # chain functions returning your type, and want to implement
    # chaining logic once and for all (in bind).
    module Monad

      # Bind operation on monads.  The type must be as follow :
      # Monad(A).bind{|A| λ(A) : Monad(B)} : Monad(B)
      def bind(&block)
        raise "Monad#bind not implemented"
      end
      
      module ClassMethods
        
        def unit
          raise "Monad.unit not implemented"
        end
        
      end
      
      def bind_(&block)
        self.bind{|*args| yield}
      end
      
    end
  end
end
