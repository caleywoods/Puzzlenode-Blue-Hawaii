require_relative "../rental"
require_relative "../season"
require "test/unit"

class TestAlohaRental < Test::Unit::TestCase

  def setup
    @s1 = Season.new('01-01', '05-31', '$75')
    @s2 = Season.new('06-01', '08-31', '$125')
    @s3 = Season.new('09-01', '12-31', '$100')
    @rental = Rental.new('Motel 6',[@s1,@s2,@s3],'$120')
  end

  def test_sanity
    assert_equal Rental, @rental.class
  end

  def test_name
    assert_equal "Motel 6", @rental.name
  end

  def test_cleaning_rate_to_i
    # a string is passed but should be converted
    assert_equal Fixnum, @rental.clean_fee.class
    assert_equal 120, @rental.clean_fee
  end

  def test_seasons_array
    assert_equal Array, @rental.seasons.class
  end

  def test_seasons_members
    assert_equal false, @rental.seasons.empty?
    assert_equal 75, @rental.seasons[0].rate
  end
end
