require 'test/unit'
require 'funkr/types/simple_record'

class TestSimpleRecords < Test::Unit::TestCase

  def test_simple_records
    r = Funkr::Types::SimpleRecord.new(name: "Paul", age: 27, city: "Rennes")
    name, age, city = r
    assert_equal("Paul", name)
    assert_equal(27, age)
    assert_equal("Rennes", city)
    name, age, city = r.with(age: 28, city: "Trouville")
    assert_equal("Paul", name)
    assert_equal(28, age)
    assert_equal("Trouville", city)

    r.name = "Paul R"
    assert_equal("Paul R", r.name)

    r.update!(name: "Paul")
    n, _x, _y = r
    assert_equal("Paul", n)
  end

end
