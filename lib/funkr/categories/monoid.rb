module Funkr
  module Monoid
    
    def mplus
      raise "Monoid#mplus not implemented"
    end
    
    module ClassMethods
      def mzero
        raise "Monoid#mzero not implemented"
      end
      
      def mconcat(list)
        list.inject(mzero){|a,e| a.mplus(e)}
      end
    end
  end
end
