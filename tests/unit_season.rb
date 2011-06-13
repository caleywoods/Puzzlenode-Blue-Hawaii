require_relative "../season.rb"
require "test/unit"

class TestSeason < Test::Unit::TestCase

  def setup
    @season = Season.new('05-07','05-20','$350')
  end

  def test_sanity
    assert_equal Season, @season.class
  end

  def test_rate_access
    assert_equal 350, @season.rate
    assert_equal Fixnum, @season.rate.class
  end

  def test_open_date_parse
    assert_equal 5, @season.first_day.month
    assert_equal 7, @season.first_day.day
  end

  def test_close_date_parse
    assert_equal 5, @season.last_day.month
    assert_equal 20, @season.last_day.day
  end

end
