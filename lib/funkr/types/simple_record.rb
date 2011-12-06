# -*- coding: utf-8 -*-
module Funkr
  module Types

    # Simple records are a simple way to create records with named AND
    # positional fields. Records can be updated on a per-field basis
    # and pattern-matched as arrays. SimpleRecord has the following
    # advantages above plain Hash :
    #
    #  - fields are strict, you can't update an unexisting field by
    #    mistyping it or by combining it with a different structure
    #  - you have easy access to fields : named AND positional
    #
    # usage : r = SimpleRecord.new(Hash), then r.field
    # r = SimpleRecord.new( name: "Paul", age: 27 )
    # r.name # => "Paul"
    # r.age  # => 27
    # name, age = r  # => [ "Paul", 27 ]
    # r.with(age: 29)  # => [ "Paul", 29 ]
    #
    # other usage :
    # class Person < SimpleRecord; fields :name, :age; end
    # Person.new( name: Paul ) => Error, missing :age
    class SimpleRecord < Array

      class << self; attr_accessor :fields_list; end
      @fields_list = nil

      def self.fields(*flds)
        self.fields_list = flds
        flds.each do |f|
          getter = f.to_sym
          setter = format("%s=", f.to_s).to_sym
          define_method(getter){ @key_vals[f] }
          define_method(setter){|nv| @key_vals[f] = nv; rebuild_array}
        end
      end

      # Create a new SimpleRecord. Pass a Hash of keys and associated
      # values if you want an inline record.
      def initialize(key_vals)
        fields = self.class.fields_list
        if not fields.nil? then # record paramétré
          if fields == key_vals.keys then # tout va bien
            @allowed_keys = fields
            @key_vals = key_vals
            rebuild_array
          else raise "#{self.class.to_s} wrong initialization, expected #{fields}" end
        else  # record anonyme
          @allowed_keys = key_vals.keys
          @key_vals = key_vals
          key_vals.each do |k,v|
            getter = k.to_sym
            setter = format("%s=", k.to_s).to_sym
            define_singleton_method(getter){ @key_vals[k] }
            define_singleton_method(setter){|nv| @key_vals[k] = nv; rebuild_array}
            self.push(v)
          end
        end
      end

      # Update a simple record non-destructively
      def with(new_key_vals)
        check_keys(new_key_vals.keys)
        self.class.new(@key_vals.merge(new_key_vals))
      end

      # Update a simple record destructively !!
      def update!(new_key_vals)
        check_keys(new_key_vals.keys)
        @key_vals.merge!(new_key_vals)
        rebuild_array
        self
      end

      def to_hash; @key_vals; end

      def to_s; @key_vals.to_s; end

      private

      def rebuild_array
        self.replace(@key_vals.values)
      end

      def check_keys(keys)
        unless keys.all?{|k| @allowed_keys.include?(k)} then
          raise "#{self.class.to_s} forbidden key in update"
        end
      end

    end
  end
end
