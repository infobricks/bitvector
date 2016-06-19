require 'test/unit'
require 'bitvector'

class TestBitVector < Test::Unit::TestCase

  def test_create
    bv = BitVector.new(4)
    assert_not_nil(bv, "Couldn't create BitVector object")
  end

  def test_bit_set
    bv = BitVector.new(4)
    bv.set(2)
    assert_equal(true, bv.get(2), "Couldn't set a bit")
    bv[3] = 1
    assert_equal(true, bv[3])
  end

  def test_bit_clear
    bv = BitVector.new(4)
    bv.set(1)
    bv.clear(1)
    assert_equal(false, bv.get(1), "Couldn't clear a bit")
    bv.set(1)
    bv[1] = 0
    assert_equal(false, bv[1], "Couldn't clear a bit")
  end

  def test_to_s
    bv = BitVector.new(4)
    bv.set(0)
    bv.set(2)
    assert_equal("1010", bv.to_s)
  end

  def test_set_all
    bv = BitVector.new(4)
    bv.set_all
    assert_equal(true, bv.get(0))
    assert_equal(true, bv.get(1))
    assert_equal(true, bv.get(2))
    assert_equal(true, bv.get(3))
  end

  def test_clear_all
    bv = BitVector.new(4)
    bv.set_all
    bv.clear_all
    assert_equal(false, bv.get(0))
    assert_equal(false, bv.get(1))
    assert_equal(false, bv.get(2))
    assert_equal(false, bv.get(3))
  end

  def test_from_s
    bv = BitVector.new('0101')
    assert_equal(false, bv.get(0))
    assert_equal(true, bv.get(1))
    assert_equal(false, bv.get(2))
    assert_equal(true, bv.get(3))
  end

  def test_concat
    x = BitVector.new('0000')
    y = BitVector.new('1111')
    z = x.concat(y)
    assert_equal('00001111', z.to_s)
  end

  def test_intersect
    x = BitVector.new('0101')
    y = BitVector.new('1100')
    z = x & y
    assert_equal('0100', z.to_s)
  end

  def test_union
    x = BitVector.new('0101')
    y = BitVector.new('1010')
    z = x | y
    assert_equal('1111', z.to_s)
  end

  def test_conjunction
    x = BitVector.new('0101')
    y = BitVector.new('0110')
    z = x.conjunction(y)
    assert_equal('1100', z.to_s)
  end

  def test_exclusive
    x = BitVector.new('0101')
    y = BitVector.new('1111')
    z = x.exclusive(y)
    assert_equal('1010', z.to_s)
  end

  def test_decimal
    x = BitVector.new('0101')
    assert_equal(10, x.to_decimal)
  end

  def test_big
    x = BitVector.new('0000000000000000000000000000000000000000000000000000000000000001')
    assert_equal(true, x[63])
    y = 1 << 63
    assert_equal(y,x.to_decimal)
  end

  def test_slice
    x = BitVector.new('01101010111')
    y = x.slice(7,9)
    assert_equal('011', y.to_s)
  end

  def test_count
    x = BitVector.new('001001')
    assert_equal(2, x.count)
  end

end
