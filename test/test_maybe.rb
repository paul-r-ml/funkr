require 'test/unit'
require 'funkr/types/maybe'
require 'funkr/extensions'

class TestMaybe < Test::Unit::TestCase

  M = Funkr::Types::Maybe

  def j(v)
    M.just(v)
  end

  def n
    M.nothing
  end

  def test_map
    assert_equal(j(6), j(5).map{|v| v+1 })
    assert_equal(n, j(5).map{|v| v+1})
  end

  def test_curry_lift
    f = M.curry_lift_proc{|x,y| x + y}
    assert_equal(j(8), f.apply(j(5)).apply(j(3)))
    assert_equal(n, f.apply(j(5)).apply(n))
  end

  def test_or_else
    assert_equal(j(10), n.or_else{j(10)})
    assert_equal(j(4), j(4).or_else{j(2)})
    # assert_nothing_raised(j(2).or_else{raise 'should not be raised'})
  end

  def test_full_lift
    f = M.full_lift_proc{|x,y| x + y}
    assert_equal(j(6), f.call(j(4),j(2)))
    assert_equal(n, f.call(j(1),n))
  end

  def test_lift_with
    assert_equal(j(7), M.lift_with(j(4),j(3)){|x,y| x + y})
  end

  def test_mconcat
    assert_equal(j(60), M.mconcat([j(10), j(20), n, j(30)]))
  end

  def test_concat
    assert_equal([10,20,30], M.concat([j(10), j(20), n, j(30)]))
  end

  def test_comparisons
    assert_equal(j(0), j(5) <=> j(5))
    assert_equal(j(-1), j(5) <=> j(7))
    assert_equal(j(1), j(2) <=> j(1))
    assert_equal(j(true), j(3) < j(7))
    assert_equal(n, j(4) <=> n)
    assert_equal(n, n <=> j(2))
  end

  def test_unbox
    assert_equal(5, j(5).unbox)
    assert_equal(5, j(5).unbox(2))
    assert_equal(nil, n.unbox)
    assert_equal(2, n.unbox(2))
  end

  def test_box
    assert_equal(j(5), M.box(5))
    assert_equal(n, M.box(nil))
  end

end
