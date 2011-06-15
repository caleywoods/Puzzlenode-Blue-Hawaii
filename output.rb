require "rubygems"
require_relative "aloha_rentals"

if ARGV.length != 2
  puts "Usage: output.rb /path/to/rentals.json /path/to/input.txt"
else
  AlohaRental.new(ARGV[0], ARGV[1]).totals
end
