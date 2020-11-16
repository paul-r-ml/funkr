require 'test/unit'
require 'funkr/extensions'

class TestExtensions < Test::Unit::TestCase

  def test_array_full_lift
    a = [1,2,3]
    b = [10,20,30]
    f = Array.full_lift_proc{|x,y| x + y}
    assert_equal([11, 21, 31, 12, 22, 32, 13, 23, 33], f.call(a,b))
    assert_equal([], f.call(a,[]))
  end

  def test_array_monad
    a = [1,2,3]
    b = [10,20,30]
    assert_equal([11, 21, 31, 12, 22, 32, 13, 23, 33],
                 a.bind do |x|
                   b.bind do |y|
                     Array.unit(x + y)
                   end
                 end)
  end

  def test_span
    assert_equal([[1, 2, 4], [5, 7, 5, 8, 2, 10]],
                 [1,2,4,5,7,5,8,2,10].span{|x| x < 5})
  end

  def test_group_seq_by
    assert_equal([[1], [2, 4], [5, 7, 5], [8, 2, 10]],
                 [1,2,4,5,7,5,8,2,10].group_seq_by{|x| x % 2})
  end

  def test_groups_of
    assert_equal([[1, 2, 4, 5], [7, 5, 8, 2], [10]],
                 [1,2,4,5,7,5,8,2,10].groups_of(4))
  end

  def test_sliding_groups_of
    assert_equal([[1, 2, 3], [2, 3, 4], [3, 4, 5], [4, 5, 6], 
                  [5, 6, 7], [6, 7, 8], [7, 8, 9], [8, 9, 10]],
                 (1..10).to_a.sliding_groups_of(3))
  end

  def test_seq_index
    assert_equal(30, (0..100).to_a.seq_index([30,31,32]))
  end

  def test_fold_with
    assert_equal(15, [1,2,3,4,5].fold_with(:+))
    assert_equal(6, [1,2,3].fold_with(:*))
    assert_equal(1, [256,2,2,2,2,2,2,2,2].fold_with(:/))
  end

  def test_diff_with
    a = [ {:v => 1}, {:v => 2}, {:v => 3}, {:v => 2}, {:v => 3} ]
    b = [ {:v => 2}, {:v => 3}, {:v => 4}, {:v => 3}, {:v => 4} ]
    assert_equal([[{:v=>1}], [{:v=>2}, {:v=>3}], [{:v=>4}]], 
                 a.diff_with(b){|x,y| x[:v] == y[:v]})
  end

  def test_make_uniq_by
    a = [ {:v => 1}, {:v => 2}, {:v => 3}, {:v => 2}, {:v => 3}, {:v => 1} ]
    assert_equal([{:v=>1}, {:v=>2}, {:v=>3}],
                 a.make_uniq_by{|x,y| x[:v] == y[:v]})
  end


  def test_mconcat_integer
    assert_equal(6, Integer.mconcat([1,2,3]))
  end

end
