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
  # the season and therefore would be subject to the nightly rate of
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
  # Returns true or false depending on whether or not date is within the season.
  def in_season?(date)
    (@first_day..@last_day).include?(date)
  end

end