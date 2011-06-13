require_relative "../aloha_rentals.rb"
require "test/unit"

class TestAlohaRental < Test::Unit::TestCase

  def setup
    @rental = AlohaRental.new('../sample_vacation_rentals.json', '../sample_input.txt')
  end

  def test_sanity
    assert_equal AlohaRental, @rental.class
  end

  def test_respond_to_parsed?
    assert_respond_to @rental, :parsed?
  end

  def test_parsed?
    assert_equal true, @rental.parsed?
  end

  def test_get_at_parsed_data
    assert_equal "Fern Grove Lodge", @rental.json[0]['name']
  end

  def test_date_file_read
    assert_equal false, @rental.dates.empty?
  end

  def test_start_date_correct_class
    assert_equal Date, @rental.start_date.class
  end

  def test_stop_date_correct_class
    assert_equal Date, @rental.stop_date.class
  end

  def test_can_access_start_date
    assert_equal 5, @rental.start_date.month
    assert_equal 7, @rental.start_date.mday
    assert_equal 2011, @rental.start_date.year
  end

  def test_can_access_stop_date
    assert_equal 5, @rental.stop_date.month
    assert_equal 20, @rental.stop_date.mday
    assert_equal 2011, @rental.stop_date.year
  end

  def test_seasons_arrays
    assert_equal false, @rental.seasons_lodges.empty?
    assert_equal false, @rental.regular_lodges.empty?
  end

  def test_fixnum_cashify
    #sert_equal "$#{
  end

end
