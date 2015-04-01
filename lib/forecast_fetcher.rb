class ForecastFetcher
  # Unit Format
  # "us" - U.S. Imperial
  # "si" - International System of Units
  # "uk" - SI w. windSpeed in mph
  DEFAULT_LOCATIONS = {
    boulder: { lat: 40.0149900, lon: -105.2705500, units: 'us', temp_unit: :f}
  }

  def initialize(api_key, locations = DEFAULT_LOCATIONS)
    @api_key = api_key
    @locations = locations
    @location_fetcher = Forecast::LocationFetcher.new(api_key)
  end

  def data
    memo = {}
    locations.each_pair do |key, location|
      response = location_fetcher.location_data(location)
      formatter = Forecast::LocationResponseFormatter.new(location, response)
      memo[key]= formatter.data
    end
    memo
  end

  private

  attr_reader :api_key, :locations, :location_fetcher
end
