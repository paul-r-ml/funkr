require 'funkr/categories'

class Array
  
  include Funkr::Categories
  
  class << self
    def unit(e); self.new([e]); end
    alias pure unit
    def mzero; self.new(); end
  end
  
  ### Categories
  
  # array est déjà un functor via map
  # include Functor 
  
  
  include Applicative
  extend Applicative::ClassMethods
  
  def apply(to)
    map do |f|
      to.map{ |t| f.call(t)}
    end.flatten(1)
  end
  
  include Alternative
  
  def or_else(&block)
    if empty? then yield
    else self end
  end
  
  
  include Monoid
  extend Monoid::ClassMethods
  
  def mplus(m_y)
    self + m_y
  end
  
  
  include Monad
  extend Monad::ClassMethods
  
  def bind(&block)
    self.map(&block).flatten(1)
  end
  
  def self.box(value)
    if value.nil? then self.mzero
    else self.unit(value) end
  end
  
  def unbox()
    if self.empty? then nil
    else self.first end
  end
  
  
  # other extensions
  class NoHead; end
  
  def head; empty? ? NoHead : first; end
  
  def tail; self.drop(1); end
  
  def all_different?
    return true if tail.empty?
    !tail.include?(head) and tail.all_different?
  end
  
  # http://www.haskell.org/ghc/docs/6.12.2/html/libraries/base-4.2.0.1/src/Data-List.html#group
  def group_seq_by(&block)
    if empty? then []
    else
      res = []
      rst = self
      while rst.any? do
        v = yield(rst.head)
        a,rst = rst.span{|x| (yield x) == v}
        res.push(a)
      end
      return res
    end
  end
  
  # http://www.haskell.org/ghc/docs/6.12.2/html/libraries/base-4.2.0.1/src/GHC-List.html#span
  def span(&block)
    inc = []
    self.each_with_index do |e,i|
      if yield(e) then inc.push(e)
      else return [ inc, self.drop(i) ] end
    end
    return [ inc, [] ]
  end

  # Constitue des groupes disjoints de n éléments au plus
  def groups_of(n)
    return [] if self.empty?
    [self.take(n)] + self.drop(n).groups_of(n)
  end

  # constitue des groupes de n éléments exactement, décalés de 1
  def sliding_groups_of(n)
    return [] if self.size < n
    [ self.take(n) ] + self.tail.sliding_groups_of(n)
  end

  # trouve l'index d'une séquence
  def seq_index(seq)
    self.sliding_groups_of(seq.size).index(seq)
  end

  def uniq_by(&block)
    result = []
    self.each do |e|
      unless result.any?{|x| yield(x,e)} then result.push(e) end
    end
    return result
  end

  # difference entre 2 tableaux, retourne le triplet [ [missing] , [intersection], [added] ]
  # codé en impératif parce que inject est trop lent :(
  def diff_with(other, &block)
    m, i, a = [], [], []
    u_s = self.uniq_by(&block)
    u_o = other.uniq_by(&block)
    u_s.each do |e| 
      if u_o.find{|x| yield(e,x)} then i.push(e)  # intersection
      else m.push(e) end   # missing
    end
    u_o.each { |e| a.push(e) unless u_s.find{|x| yield(e,x)} } # added
    return [ m, i, a ]
  end
  
end
