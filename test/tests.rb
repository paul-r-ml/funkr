require 'rubygems'
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

puts Maybe.mconcat([Maybe.just(10),
                    Maybe.just(20),
                    Maybe.nothing,
                    Maybe.just(30)])

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


puts "\n> group_seq_by"
puts([1,2,4,5,7,5,8,2,10].group_seq_by{|x| x % 2}.inspect)
