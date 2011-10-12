module Funkr
  # Should not be used directly
  class Matcher
    
    def initialize(match)
      @const, *@data = match
      @runner = nil
      @undefined = self.class.constructs.clone
    end
    
    def self.build_matchers(constructs)
      @constructs = constructs
      constructs.each do |c|
        name, *data = c
        define_method(name) do |&b|
          @undefined.delete(name)
          if @const == name then
            @runner = b
          end
        end
      end
    end
    
    def self.constructs; @constructs; end
    
    def run_match
      if @undefined.any? then
        raise "Incomplete match, missing : #{@undefined.join(" ")}"
      end
      @runner.call(*@data)
    end
    
  end
end
