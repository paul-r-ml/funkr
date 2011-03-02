module Funkr
  module Categories
    module Applicative
      
      def apply
        raise "Applicative#apply not implemented"
      end

      module ClassMethods
        def lift_proc(&block)
          self.pure(block.curry)
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
          lift_proc(&block).
          apply(self).apply(other)
      end

    end
  end
end
