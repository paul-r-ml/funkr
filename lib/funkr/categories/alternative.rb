module Funkr
  module Categories
    
    # Functors for which alternative (OR) behaviour can be defined
    module Alternative
      
      # Provide an alternative. The type must be as follow :
      #   Functor(A).or_else{ Functor(A) } : Functor(A)
      def or_else
        raise "Alternative#or_else not implemented"
      end
      
    end
  end
end
