$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require 'rubygems'
require 'funkr'
require 'funkr/types'
require 'funkr/extensions'

include Funkr::Types

m = Maybe.just(5)

puts(m.match do |on|
       on.nothing{ Maybe.nothing }
       on.just{|v| Maybe.just(v + 1) }
     end.to_s)

puts(m.map{|v| v+1 })


n = Maybe.nothing

puts(n.match do |on|
       on.nothing{ Maybe.nothing }
       on.just{|v| Maybe.just(v + 1) }
     end.to_s)


puts "\n> Curry lift"
f = Maybe.curry_lift_proc{|x,y| x + y}
puts f.apply(m).apply(m)
puts f.apply(m).apply(n)
puts f.apply(m).apply(n.or_else{Maybe.just(10)})

puts "\n> Full lift"
f = Maybe.full_lift_proc{|x,y| x + y}
puts f.call(m,m)
puts f.call(m,n)

puts "\n> Lift with"
puts Maybe.lift_with(m,m){|x,y| x + y}

puts "\n> mconcat"
puts Maybe.mconcat([Maybe.just(10),
                    Maybe.just(20),
                    Maybe.nothing,
                    Maybe.just(30)])

puts "\n> Comparisons"
puts(m <=> m)
puts(m <=> (m.map{|v| v+1}))
puts(m < (m.map{|v| v+1}))
puts(m <=> n)

puts "\n> Boxing and unboxing"
puts m.unbox.inspect
puts n.unbox.inspect
puts (Maybe.box(12)).unbox.inspect
puts (Maybe.box(nil)).unbox.inspect


a = [1,2,3]
b = [10,20,30]

puts "\n> Array full lift"
f = Array.full_lift_proc{|x,y| x + y}
puts f.call(a,b).inspect
puts f.call(a,[]).inspect

puts "\n> Array monad"
puts(a.bind do |x|
       b.bind do |y|
         Array.unit(x + y)
       end
     end.inspect)


puts "\n> span"
puts([1,2,4,5,7,5,8,2,10].span{|x| x < 5}.inspect)

puts "\n> group_seq_by"
puts([1,2,4,5,7,5,8,2,10].group_seq_by{|x| x % 2}.inspect)

puts "\n> groups_of"
puts([1,2,4,5,7,5,8,2,10].groups_of(4).inspect)

puts "\n> sliding_groups_of"
puts((1..10).to_a.sliding_groups_of(3).inspect)

puts "\n> seq_index (30)"
puts((0..100).to_a.seq_index([30,31,32]))

puts "\n> diff_with"
a = [ {:v => 1}, {:v => 2}, {:v => 3}, {:v => 2}, {:v => 3} ]
b = [ {:v => 2}, {:v => 3}, {:v => 4}, {:v => 3}, {:v => 4} ]
puts(a.diff_with(b){|x,y| x[:v] == y[:v]}.inspect)

puts "\n> uniq_by"
a = [ {:v => 1}, {:v => 2}, {:v => 3}, {:v => 2}, {:v => 3}, {:v => 1} ]
puts(a.uniq_by{|x,y| x[:v] == y[:v]}.inspect)
