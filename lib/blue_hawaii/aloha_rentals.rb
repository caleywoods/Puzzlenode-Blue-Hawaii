%w[rubygems json date].each {|x| require x}
%w[rental season cashify].each {|x| require_relative x}

class AlohaRental
  attr_accessor :json, :rentals, :seasons
  attr_reader :start_date, :stop_date

  TAX = 1.0411416

  # Accepts a json file containing vacation rentals and a date file that represents a stay range.
  #
  # json_file - The vacation rentals represented in JSON format.
  # date_file - The file containing a stay range. In the format: 2011/05/07 - 2011/05/20
  #
  # Example:
  #
  #   a = AlohaRental.new('./sample_vacation_rentals.json', './sample_input.txt')
  #
  # Returns an AlohaRental class object and calls parse
  def initialize(json_file, date_file)
    @json_file, @date_file = json_file, date_file

    parse
  end

  # Parses the json_file using the JSON lib into an ivar named @json and parses the
  # date_file into two ivars named @start_date and @stop_date using Regex match groups.
  #
  # Notes:
  #
  #   1.) The Regex pattern used here will never fail due to using *, could probably use +
  #
  # After parsing the json file and date file it calls builder.
  def parse
    @json = JSON.parse(File.read(@json_file))
    dates = File.read(@date_file)

    dates =~ /(.*) \- (.*)/
    @start_date, @stop_date = Date.parse($1), Date.parse($2)

    builder
  end

  # Builds an array of rentals by walking the @json ivar we setup in the parse method.
  # If the lodge has seasons it should respond to ['seasons'] and we then need to setup
  # an Array of Season objects and then create a Rental object containing those seasons.
  #
  # Notes:
  #
  #   1.) Notice if a lodge doesn't have season(s) we create a season that runs all year.
  #   2.) If cleaning fee doesn't exist it gets set to zero by the constructor on the Rental class.
  #
  # Once we've fininshed building the @rentals array all that's left to do is call the totals method.
  def builder
    @rentals = []

    @json.each do |lodge|
      if lodge['seasons']
        seasons = []
        lodge['seasons'].each do |season|
          season.each_value {|x| seasons << Season.new(x['start'],x['end'], x['rate']) }
        end
        @rentals << Rental.new(lodge['name'],seasons,lodge['cleaning fee'])
      else
        @rentals << Rental.new(lodge['name'],[Season.new('01-01','12-31',lodge['rate'])],lodge['cleaning fee'])
      end
    end
  end

  # This is the only method meant to be called on an instance of this class.
  #
  # Examples:
  #
  #   a = AlohaRental.new('./sample_vacation_rentals.json', './sample_input.txt)
  #   a.totals
  #   #returns totals for each rental
  #   #i.e => Fern Grove Lodge: $2474.79
  #
  # Notes:
  #
  #   1.) The cashify method used on line 94 comes from lib/cashify.rb and 
  #       is a method added to the Float class to take an integer and output 
  #       a string in the format: $n.nn
  #
  # Returns the totals for each rental in the format: rental.name: $rental.price
  def totals
    totals = Hash[@rentals.map do |rental|
      [rental.name, (rental.total(@start_date, @stop_date) + rental.clean_fee) * TAX]
    end]

    totals.each do |resort|
      puts resort.first + ": " + resort.last.cashify
    end
  end

end
