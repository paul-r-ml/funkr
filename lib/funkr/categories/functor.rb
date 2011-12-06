# -*- coding: utf-8 -*-
module Funkr
  module Categories
    
    # A functor is a container that can be mapped over
    module Functor

      # Map over the constructor. The type must be as follow :
      #   Functor(A).map{|A| λ(A) : B} : Functor(B)
      def map
        raise "Functor#map not implemented"
      end


      module ClassMethods

      end
    


    end
  end
end
