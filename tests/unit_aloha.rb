require_relative "../aloha_rentals.rb"
require "test/unit"

class TestAlohaRental < Test::Unit::TestCase

  def setup
    @rental = AlohaRental.new('../sample_vacation_rentals.json', '../sample_input.txt')
  end

  def test_sanity
    assert_equal AlohaRental, @rental.class
  end

  def test_get_at_parsed_data
    assert_equal "Fern Grove Lodge", @rental.json[0]['name']
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

  def test_rental_array
    assert_equal false, @rental.rentals.empty?
  end

  def test_float_cashify
    assert_equal "$75.00", 75.00.cashify
  end

end
