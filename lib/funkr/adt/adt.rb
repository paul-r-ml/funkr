require "funkr/adt/matcher"

module Funkr
  class ADT

    def initialize(const, *data)
      @const, @data = const, data
    end
    
    def self.adt(*constructs)
      build_adt(constructs)
      build_matcher(constructs)
    end

    def self.match_method=(method)
      @match_method = method
    end

    self.match_method = :safe
    
    def self.matcher; @matcher; end
    
    def match
      m = self.class.matcher.new(normal_form)
      yield m
      m.run_match
    end
    
    def to_s
      format("%s%s%s",
             @const,
             @data.any? ? " : " : "",
             @data.map(&:inspect).join(" ") )
    end
    
    private

    attr_reader :const, :data
    
    def normal_form; [@const, *@data]; end
    
    def self.build_adt(constructs)
      constructs.each do |c,*d|
        define_singleton_method(c) do |*data|
          self.new(c,*data)
        end
        define_method(format("%s?",c).to_sym) do
          const() == c
        end
      end
    end
    
    def self.build_matcher(constructs)
      @matcher = Class.new(Funkr::Matcher) do
        build_matchers(constructs)
      end
    end

  end
end
