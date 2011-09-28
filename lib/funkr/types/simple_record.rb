module Funkr
  module Types
    
    class SimpleRecord < Array
      ### usage : r = SimpleRecord.new(Hash), then r.field
      ### r = SimpleRecord.new( name: "Paul", age: 27 )
      ### r.name => "Paul"  ; r.age => 27
      ### name, age = r

      ### other usage :
      ### class Person < SimpleRecord; fields :name, :age; end
      ### Person.new( name: Paul ) => Error, missing :age

      class << self; attr_accessor :fields_list; end
      @fields_list = nil

      def self.fields(*flds); self.fields_list = flds; end

      def initialize(key_vals)
        fields = self.class.fields_list
        if not fields.nil? and fields != key_vals.keys then
          raise "#{self.class.to_s} wrong initialization, expected #{fields}"
        end
        @key_vals = key_vals
        key_vals.each do |k,v|
          getter = k.to_sym
          setter = format("%s=", k.to_s).to_sym
          define_singleton_method(getter){ @key_vals[k] }
          define_singleton_method(setter){|nv| @key_vals[k] = nv}
          self.push(v)
        end
      end
      
      def with(new_key_vals)
        self.class.new(@key_vals.merge(new_key_vals))
      end
      
      def to_hash; @key_vals; end
      
      def to_s; @key_vals.to_s; end
      
    end

  end
end
