load "maybe.rb"
load "extensions.rb"

m = Maybe.just(5)

puts(m.match do |on|
       on.nothing{ Maybe.nothing }
       on.just{|v| Maybe.just(v + 1) }
     end.to_s)

puts(m.map{|v| v+1 })

val = (m.match do |on|
         on.nothing{ Maybe.nothing }
         on.just{|v| Maybe.just(v + 1) }
       end)

puts m.map{|v| v + 1}


n = Maybe.nothing

puts(n.match do |on|
       on.nothing{ Maybe.nothing }
       on.just{|v| Maybe.just(v + 1) }
     end.to_s)


f = Maybe.lift_proc{|x,y| x + y}


puts f.apply(m).apply(m)
puts f.apply(m).apply(n)
puts f.apply(m).apply(n.or_else{Maybe.just(10)})


puts Maybe.mconcat([Maybe.just(10),
                    Maybe.just(20),
                    Maybe.nothing,
                    Maybe.just(30)])
