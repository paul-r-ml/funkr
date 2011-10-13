require 'test/unit'
require 'funkr/types/container'

class TestContainer < Test::Unit::TestCase
  C = Funkr::Types::Container

  def test_comparable
    # assert_equal(C.new('foo'), C.new('foo'))
  end

  def test_container
    c = C.new("Value")
    assert_equal("Value", c.unbox)
    assert_equal("eulaV", c.map(&:reverse).unbox)
  end

end
