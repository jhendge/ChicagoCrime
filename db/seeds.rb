
require 'csv'
require 'forecast_io'

class OneCrime
	attr_reader :date, :primary_type, :description, :location_description, :latitude, :longitude, :community_area, :district
  def initialize(options={})
		@date = options[:date]
    @primary_type = options[:primary_type]
    @description = options[:description]
    @location_description = options[:location_description]
    @latitude = options[:latitude]
    @longitude = options[:longitude]
    @community_area = options[:community_area]
    @district = options[:district]
  end
end

class Parse
  attr_reader :crimes
  def initialize
    @crimes = []
  end

  def load_crimes(filename)
    CSV.foreach(filename, headers: true, header_converters: :symbol) do |row_data|
      @crimes << OneCrime.new(row_data)
    end
  end
end

parse = Parse.new
parse.load_crimes("Crimes_-_2013.csv")

parsed_crimes = parse.crimes

p parsed_crimes

parsed_crimes.each do |wrongdoing|
  Crime.create!(date: wrongdoing.date, primary_type: wrongdoing.primary_type, description: wrongdoing.description, location_description: wrongdoing.location_description, latitude: wrongdoing.latitude, longitude: wrongdoing.longitude, community_area: wrongdoing.community_area, district: wrongdoing.district)
end













