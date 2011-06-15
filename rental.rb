require "date"
require_relative "string_splitter"
include StringSplitter

class Rental
  attr_accessor :name, :seasons, :clean_fee

  # Accepts a name, seasons array, and cleaning fee. It is
  # expected that the Array of seasons are Season objects.
  #
  # Examples:
  #
  #   s1 = Season.new('01-01', '06-30', '$75')
  #   s2 = Season.new('07-01', '09-30', '$125')
  #   s3 = Season.new('10-01', '12-31', '$50')
  #
  #   r = Rental.new('Foo Gardens', [s1,s2,s3], '$98')
  #
  # Notes:
  #
  #   1.) If we don't supply a cleaning fee it's defaulted
  #       to zero for simplicity.
  #   2.) split_em_up comes from string_spliter and does
  #       a split('$').last on the cleaning fee.
  #
  # Returns a Rental class object.
  def initialize(name, seasons, clean_fee="$0")
    @name, @seasons = name, seasons
    @clean_fee = if clean_fee.nil?
                   0
                 else
                   split_em_up(clean_fee).to_i
                 end
  end

  # Accepts a start date and stop date to iterate
  # over the Array of seasons supplied to the class
  # and create a total for each season for the given
  # stay range.
  #
  # start_date - A Date object representing the opening day of your stay
  # stop_date - A Date object representing the departing day of your stay
  #
  # Notes:
  #
  #   1.) Meant to be called externally from another
  #       class and passing in the stay range but
  #       could be called on its own.
  #
  # Examples:
  #
  #   d1 = Date.civil(2011,05,07)
  #   d2 = Date.civil(2011,05,20)
  #   r.total(d1, d2)
  #   # => should return $75 * 13 nights = 975.0
  #
  # Returns the total price for each season as a float for precision calculations.
  def total(start_date, stop_date)
    total = 0
    @seasons.map do |season|
      (start_date...stop_date).each do |date| #using ... instead of .. because we don't pay on the final day
        total += season.rate unless !season.in_season?(date) #add to total unless the date isn't in season
      end
    end
    total.to_f
  end

end
