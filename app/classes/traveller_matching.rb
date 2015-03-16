require 'algorithms'
require 'geocoder'

include Containers
include Geocoder

# Matches passengers to drivers.
class TravellerMatching

  # Initializes the variables needed and geocodes the addresses for the travellers and the destinations.
  #
  # * *Args*    :
  #   - +trip+ -> the trip with the inputted information from the user
  def initialize(trip)
    @trip = trip
    @drivers = @trip.drivers
    @passengers = @trip.passengers
    @driver_coordinates = []
    @passenger_coordinates = []
    @destination_coordinates = geocode_address(@trip.destination_address)
    geocode_traveller_addresses
  end

  # Takes an address and gets the latitude and longitude of it.
  #
  # * *Args*    :
  #   - +address+ -> an address
  # * *Returns* :
  #   - an array with the latitude and longitude
  private
  def geocode_address(address)
    #Geocoder.config_for_lookup(:geocoder_ca)
    Geocoder.configure({:lookup => :esri, :units => :km, :timeout => 5})
    results = Geocoder.coordinates(address)
    [results[0], results[1]]
  end

  # Geocodes the drivers and passengers addresses.
  private
  def geocode_traveller_addresses
    @drivers.each do |driver|
      @driver_coordinates << geocode_address(driver.address)
    end

    @passengers.each do |passenger|
      @passenger_coordinates << geocode_address(passenger.address)
    end
  end

  # Debugging methods to show the corresponding coordinates to the given addresses for the destinations and travellers.
  #
  # * *Returns* :
  #   - a string of the addresses and coordinates
  private
  def get_lat_and_long_of_travellers
    return_string = "--Destination--\n"
    return_string << "#{@trip.destination_address}\n"
    return_string << @destination_coordinates.to_s
    return_string << "\n--Drivers--\n"

    @driver_coordinates.each_with_index do |coordinates, index|
      return_string << @drivers[index].to_s << "\n"
      return_string << coordinates.to_s << "\n"
    end

    return_string << "\n--Passengers--\n"

    @passenger_coordinates.each_with_index do |coordinates, index|
      return_string << @passengers[index].to_s << "\n"
      return_string << coordinates.to_s << "\n"
    end

    return_string
  end

  # Finds the matching of drivers and passengers and adds them to route objects.
  #
  # * *Returns* :
  #   - the trip with the routes added
  public
  def group_travellers
    min_pq_lambda = lambda{|x, y| (x <=> y) == -1}
    nearest_passengers_to_drivers = Hash.new
    drivers_with_seats_left = []

    @drivers.each_with_index do |driver, d_index|
      drivers_with_seats_left << driver
      nearest_passengers_to_drivers[driver] = PriorityQueue.new(&min_pq_lambda)

      @passengers.each_with_index do |passenger, p_index|
        nearest_passengers_to_drivers[driver].push(passenger, deviated_distance_from_path(@driver_coordinates[d_index], @passenger_coordinates[p_index]))
      end
    end

    pairing = Hash.new
    current_driver_capacity = Hash.new(0)

    until drivers_with_seats_left.empty? do
      drivers_with_seats_left.each_with_index do |driver, index|
        if current_driver_capacity[driver] >= driver.number_of_passengers || nearest_passengers_to_drivers[driver].empty?
          drivers_with_seats_left.delete_at(index)
          next
        end

        until nearest_passengers_to_drivers[driver].empty? do
          passenger = nearest_passengers_to_drivers[driver].pop

          unless pairing.has_key?(passenger)
            pairing[passenger] = driver
            current_driver_capacity[driver] += 1
            break
          end
        end
      end
    end

    @passengers.each do |passenger|
      unless pairing.has_key?(passenger)
        puts "Passenger [#{passenger}] could not find a ride"
      end
    end

    driver_routes = Hash.new

    pairing.each do |passenger, driver|
      if driver_routes[driver].nil?
        driver_routes[driver] = RouteContainer.new(driver)
        @trip.add_route(driver_routes[driver])
      end

      driver_routes[driver].add_passenger(passenger)
    end

    @trip
  end

  # Finds the distance from driver to the passenger to the destinations subtract the straight line distance
  # from the driver to the destinations.
  #
  # * *Args*    :
  #   - +driver_coordinates+ -> the drivers coordinates as a two element array in the format [latitude, longitude]
  #   - +passenger_coordinates+ -> the passengers coordinates as a two element array in the format [latitude, longitude]
  # * *Returns* :
  #   - the difference in distance
  private
  def deviated_distance_from_path(driver_coordinates, passenger_coordinates)
    driver_destination_distance = Math.sqrt((driver_coordinates[0] - @destination_coordinates[0]) ** 2 + (driver_coordinates[1] - @destination_coordinates[1]) ** 2)
    driver_passenger_distance = Math.sqrt((driver_coordinates[0] - passenger_coordinates[0]) ** 2 + (driver_coordinates[1] - passenger_coordinates[1]) ** 2)
    passenger_destination_distance = Math.sqrt((passenger_coordinates[0] - @destination_coordinates[0]) ** 2 + (passenger_coordinates[1] - @destination_coordinates[1]) ** 2)

    driver_passenger_distance + passenger_destination_distance - driver_destination_distance
  end
end