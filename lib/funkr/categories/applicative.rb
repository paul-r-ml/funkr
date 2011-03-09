module Funkr
  module Categories
    module Applicative
      
      def apply
        raise "Applicative#apply not implemented"
      end

      module ClassMethods
        def curry_lift_proc(&block)
          self.pure(block.curry)
        end

        def full_lift_proc(&block)
          lambda do |*args|
            args.inject(curry_lift_proc(&block)) do |a,e|
              a.apply(e)
            end
          end
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
