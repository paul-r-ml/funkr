require 'funkr/categories'

module Funkr
  module Types
    class Container

      include Funkr::Categories

      def initialize(value)
        @value = value
      end

      def unbox; @value; end

      def to_s; format("{- %s -}", @value.to_s); end

      include Functor

      def map(&block)
        self.class.new(yield(@value))
      end

      include Monoid
      extend Monoid::ClassMethods

      def mplus(c_y)
        self.class.new(@value.mplus(c_y.unbox))
      end

    end
  end
end
