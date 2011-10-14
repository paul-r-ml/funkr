require 'test/unit'
require 'funkr/extensions/hash'

class TestHash < Test::Unit::TestCase

  def test_map_v
    assert_equal( {a: 2, b: 3},
           {a: 1, b: 2}.map_v{|v| v + 1} )
    h = Hash.new(:patate)
    assert_equal( :patate, h.map_v{|x| x + 1}[:foo] )
  end

end
