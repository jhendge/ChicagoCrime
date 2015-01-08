require 'csv'
require 'forecast_io'

# Create a OneCrime class so that when the crimes are parsed from the 2013 Chicago Crime CSV file, the crimes can be converted into Ruby Crime objects so that they can be manipulated in Ruby

class OneCrime
  attr_reader :date, :primary_type, :description, :location_description, :latitude, :longitude, :community_area, :district, :block
  def initialize(options={})
    @date = options[:date]
    @primary_type = options[:primary_type]
    @description = options[:description]
    @location_description = options[:location_description]
    @latitude = options[:latitude]
    @longitude = options[:longitude]
    @community_area = options[:community_area]
    @district = options[:district]
    @block = options[:block]
  end
end

# Create a Parse class which loads the crimes from the CSV files, parses them, and converts each individual crime into a OneCrime object

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

# Create an instance of Parse in order to load the crimes from the CSV file.
parse = Parse.new

# parse.load_crimes("db/test.csv")
parse.load_crimes("Crimes_-_2013.csv")

parsed_crimes = parse.crimes

# Once the crimes are loaded and parsed, create Crimes that can be stored in the database
parsed_crimes.each do |wrongdoing|
  Crime.create!(date: wrongdoing.date, primary_type: wrongdoing.primary_type, description: wrongdoing.description, location_description: wrongdoing.location_description, latitude: wrongdoing.latitude, longitude: wrongdoing.longitude, community_area: wrongdoing.community_area, district: wrongdoing.district, block: wrongdoing.block)
end

# Create a Client class 

class Client
    def get(url)
      # create the HTTP GET request
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(URI(url))

      # connect to the server and send the request
      response = http.request(request)
      response.body

      response
    end
  end


  @crimes = Crime.all 
  @homicides = Crime.where(primary_type: "HOMICIDE")

  forecasting = Client.new
  forecastAPIkey = "afcc7a0db1d5eef67ebc4e50464b1bff"
  latitude = 41.87
  longitude = -87.62

  def parse_time(crimedate)
    date = crimedate.split(" ")[0]
    x = date.gsub("/", " ").split(" ")
    format = x[2] + "-" + x[0] + "-" + x[1] + "T12:00:00"
    format
  end


# For each homicide, make an API call to obtain and update the temperature, and save it to the database so that API calls are not made each time you want a homicide's temp

  @homicides.each do |crime|

    time = parse_time(crime.date)
    @api_call = JSON.parse(forecasting.get("https://api.forecast.io/forecast/"+forecastAPIkey+"/"+latitude.to_s+","+longitude.to_s+","+(time)).body)


    temp = @api_call["currently"]["temperature"]

    specific_crime = Crime.find(crime.id)

    crime.update_attributes(temp: temp)
  end