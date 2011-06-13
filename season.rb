require "rubygems"
require "date"
require_relative "string_splitter"
include StringSplitter

class Season
  attr_accessor :first_day, :last_day, :rate

  # Accepts an open date, close date, and rate and creates a Season object
  # to be utilized in an Array as part of a Rental.
  #
  # open_date - The opening date of the season, in the format: MM-DD
  # close_date - The closing date of the season, in the format: MM-DD
  # rate - The nightly rate to be charged for each night stayed during the season
  #
  # Examples:
  #
  #   s1 = Season.new('01-01', '12-31', '$100')
  #
  # Returns a Season class object
  def initialize(open_date, close_date, rate)
    open_date =~ /(\d{2})\-(\d{2})/
    open_month, open_day = $1.to_i, $2.to_i

    close_date =~ /(\d{2})\-(\d{2})/
    close_month, close_day = $1.to_i, $2.to_i

    if open_month > close_month
      @first_day = Date.civil(2011, open_month, open_day)
      @last_day = Date.civil(2012, close_month, close_day)
    else
      @first_day = Date.civil(2011, open_month, open_day)
      @last_day = Date.civil(2011, close_month, close_day)
    end

    @rate = split_em_up(rate).to_i
  end

  # Accepts a date in order to check if the given date falls within
  # the season and therefor would be subject to the nightly rate of
  # this season.
  #
  # date - A date of Date class supplied for checking against the season range
  #
  # Examples:
  #
  #   date = Date.civil(2011,05,07)
  #   in_season?(date)
  #   # => true
  #
  # Notes:
  #
  #   1.) This is probably ripe for refactoring but given time constraints
  #       it must work, it's a known tradeoff.
  #
  # Returns true or false depending on whether or not date is within the season.
  def in_season?(date)
    #2011-10-28 - opening stay date, passes
    #2011-10-29 - passes
    #season 1
    #2011-09-01 - open day of season
    #2012-01-31 - last day of season
    #season 2
    #2011-08-01 - first day of seaason
    #2011-08-31 - last day of season
    #in_season = ((date.month >= @open_month && date.day >= @open_day) ||
                 #(date.month < @open_month && date.month <= @close_month && date.day <= @close_day)) &&
                #((date.month <= @close_month && date.day <= @close_day) ||
                 #(@close_month == 2 && date.month <= @close_month && date.day > @close_day) ||
                 #(date.month > @close_month && date.month >= @open_month && date.day >= @open_day))
    (@first_day..@last_day).include?(date)
       #this covers the standard idea that a date of '02-01' fits into a season running '01-01' to '03-01'
       #this would be false on date '10-01' for a season running '12-01' to '10-31' this season spans a year
    #if (date.month >= @open_month && date.day >= @open_day) && (date.month <= @close_month && date.day <= @close_day)
      #true
      #this covers a date of '10-01' for a season running '12-01' to '10-31' this season spans a year
      #there's no check for date.day being greater than or equal to the open_day, what if the season opened '12-15'? That would fail
    #elsif (date.month < @open_month && date.month <= @close_month && date.day <= @close_day)
      #true
      #this covers a date of '10-01' for a season running '09-01' to '01-31' this season spans a year
    #elsif (date.month > @open_month && date.month <= @close_month && date.day <= @close_day)
      #true
    #else
      #false
    #end
  end

end
