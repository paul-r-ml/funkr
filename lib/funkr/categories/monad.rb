module Funkr
  module Monad
    
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
