# -*- coding: utf-8 -*-
module Enumerable
  
  # enumerable extensions

  # Folds an enumerable with an operator
  def fold_with(sym)
    self.inject{|a,e| a.public_send(sym,e)}
  end

  # Check if all elements in collection are differents
  def all_different?
    a = self.to_a.drop(1)
    self.each do |e|
      return false if a.include?(e)
      a.shift
    end
    return true
  end
  
  # http://www.haskell.org/ghc/docs/6.12.2/html/libraries/base-4.2.0.1/src/Data-List.html#group
  def group_seq_by(&block)
    res = []
    rst = self.to_a
    while !rst.empty? do
      v = yield(rst.first)
      a,rst = rst.span{|x| (yield x) == v}
      res.push(a)
    end
    return res
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

  # builds up disjoint groups of n elements or less
  def groups_of(n)
    g = self.take(n)
    return [] if g.empty?
    [g] + self.drop(n).groups_of(n)
  end

  # builds up sliding groups of exactly n elements
  def sliding_groups_of(n)
    return [] if self.size < n
    [ self.take(n) ] + self.drop(1).sliding_groups_of(n)
  end

  # find the position of a sequence
  #  [1,2,3,4,5,4,3,2,1].seq_index([4,3])  # => 5
  def seq_index(seq)
    self.sliding_groups_of(seq.size).index(seq)
  end

  # Takes a block predicate p(x,y) and builds an array of elements so
  # that for any (a,b), a being before b in the list, p(a,b) holds.
  def make_uniq_by(&block)
    result = []
    self.each do |e|
      unless result.any?{|x| yield(x,e)} then result.push(e) end
    end
    return result
  end

  # compare 2 enumerables, and returns [ [missing] , [intersection], [added] ]
  def diff_with(other, &block)
    m, i, a = [], [], []
    u_s = self.make_uniq_by(&block)
    u_o = other.make_uniq_by(&block)
    u_s.each do |e| 
      if u_o.find{|x| yield(e,x)} then i.push(e)  # intersection
      else m.push(e) end   # missing
    end
    u_o.each { |e| a.push(e) unless u_s.find{|x| yield(e,x)} } # added
    return [ m, i, a ]
  end

end
