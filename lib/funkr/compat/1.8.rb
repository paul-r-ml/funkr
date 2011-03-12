class Proc
  
  def curry
    case self.arity
    when 2 then curry2
    when 3 then curry3
    when 4 then curry4
    when 5 then curry5
    else raise "Can't curry more than 5 arguments"
    end
  end
  
  def curry2
    lambda{|a|
      lambda{|b| self.call(a,b)}}
  end
  
  def curry3
    lambda{|a|
      lambda{|b| 
        lambda{|c| self.call(a,b,c)}}}
  end
  
  def curry4
    lambda{|a|
      lambda{|b|
        lambda{|c| 
          lambda{|d| self.call(a,b,c,d)}}}}
  end
  
  def curry5
    lambda{|a|
      lambda{|b|
        lambda{|c|
          lambda{|d|
            lambda{|e| self.call(a,b,c,d,e)}}}}}
  end
  
end

class Object
  def define_singleton_method(name, &block)
    singleton = class << self; self end
    singleton.send(:define_method, name) do |*args|
      block.call(*args)
    end
  end
end
  
