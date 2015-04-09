require 'algorithms'
include Containers

##
# Matches passengers to drivers for a given trip object without routes.
class TravellerMatching
  attr_reader :trip

  ##
  # Initializes the variables needed and runs calls the method to group the travellers.
  #
  # * *Args*    :
  #   - +trip+ -> the trip with the inputted information from the user
  def initialize(trip)
    @trip = trip
    @drivers = @trip.drivers
    @passengers = @trip.passengers
    @destination_latitude = @trip.destination_latitude
    @destination_longitude = @trip.destination_longitude
    group_travellers
  end

  private
  ##
  # Finds the matching of drivers and passengers and adds them to route objects. Points are considered to be in a polar
  # coordinate system with the destination as the pole.
  #
  # * *Returns* :
  #   - the trip with the routes added
  def group_travellers
    #-------------------------------------------------------------------------------------------------------------------
    # If drivers are going by themselves, remove them from the algorithm and give them a route later.
    #-------------------------------------------------------------------------------------------------------------------

    drivers = []
    drivers_going_alone = []

    total_capacity = 0

    @drivers.each do |driver|
      total_capacity += driver.number_of_passengers

      if driver.number_of_passengers == 0
        drivers_going_alone << driver
      else
        drivers << driver
      end
    end

    if @passengers.length > total_capacity
        raise "Too many passengers for the number of seats. Over by #{@passengers.length - total_capacity} seat(s)}."
    end

    #-------------------------------------------------------------------------------------------------------------------
    # Remove passengers from the algorithm who have a preference of going with somebody.
    #-------------------------------------------------------------------------------------------------------------------

    passengers = []
    driver_passenger_whitelist = Hash.new

    @passengers.each do |passenger|
      passenger_has_preference = false

      @trip.driver_passenger_whitelist.each do |preference|
        if passenger.to_s == preference[1].to_s
          if driver_passenger_whitelist[preference[0]].nil?
            driver_passenger_whitelist[preference[0]] = []
          end

          driver_passenger_whitelist[preference[0]] << preference[1]
          passenger_has_preference = true
        end
      end

      unless passenger_has_preference
        passengers << passenger
      end
    end

    #-------------------------------------------------------------------------------------------------------------------
    # Pair the passengers and drivers
    #-------------------------------------------------------------------------------------------------------------------

    pairing = Hash.new

    drivers.each do |driver|
      pairing[driver] = []
    end

    passengers.each do |passenger|
      min_deviation = 1000000
      min_deviation_pair = nil

      drivers.each do |driver|
        deviation = deviated_distance_from_path(driver.longitude, driver.latitude, @destination_longitude, @destination_latitude, passenger.longitude, passenger.latitude)

        if deviation < min_deviation
          min_deviation = deviation
          min_deviation_pair = [driver, passenger]
        end
      end

      if pairing[min_deviation_pair[0]].nil?
        pairing[min_deviation_pair[0]] = []
      end

      pairing[min_deviation_pair[0]] << min_deviation_pair[1]
    end

    #-------------------------------------------------------------------------------------------------------------------
    # Re-allocate passengers for vehicles that are over capacity.
    #-------------------------------------------------------------------------------------------------------------------

    # Add passengers to the drivers that were in the whitelist
    driver_passenger_whitelist.each do |driver, passengers|
      pairing[driver].concat passengers
    end

    # Create a hash that stores the drivers and their corresponding capacities
    driver_capacities = Hash.new
    drivers.each do |driver|
      driver_capacities[driver] = driver.number_of_passengers
    end

    # Determine which drivers are over capacity and have extra seats
    drivers_over_capacity = []
    drivers_with_extra_seats = []

    pairing.each do |driver, passengers|
      if !driver_passenger_whitelist[driver].nil? && driver_passenger_whitelist[driver].length > driver_capacities[driver]
        raise "Too many passengers in the whitelist for #{driver.name}"
      end

      if passengers.length > driver_capacities[driver]
        drivers_over_capacity << driver
      elsif passengers.length < driver_capacities[driver]
        drivers_with_extra_seats << driver
      end
    end

    # Move passenger from over capacity vehicles to ones that have extra seats
    until drivers_over_capacity.empty?
      shortest_distances = PriorityQueue.new(&lambda{|x, y| (x <=> y) == -1})

      pairing[drivers_over_capacity[-1]].each do |passenger|
        # Ignore passengers in whitelist
        passenger_in_whitelist = false

        unless driver_passenger_whitelist[drivers_over_capacity[-1]].nil?
          driver_passenger_whitelist[drivers_over_capacity[-1]].each do |whitelist_passenger|
            if passenger.to_s == whitelist_passenger.to_s
              passenger_in_whitelist = true
              break
            end
          end
        end

        if passenger_in_whitelist
          next
        end

        # Add distances to queue
        drivers_with_extra_seats.each do |driver_with_extra_seats|
          deviated_distance = deviated_distance_from_path(@destination_longitude, @destination_latitude, driver_with_extra_seats.longitude, driver_with_extra_seats.latitude, passenger.longitude, passenger.latitude)
          shortest_distances.push([driver_with_extra_seats, drivers_over_capacity[-1], passenger], deviated_distance)
        end
      end

      match = shortest_distances.pop
      pairing[match[1]].delete(match[2])
      pairing[match[0]] << match[2]

      if pairing[match[1]].length <= driver_capacities[match[1]]
        drivers_over_capacity.pop
      end

      if pairing[match[0]].length >= driver_capacities[match[0]]
        drivers_with_extra_seats.delete(match[0])
      end
    end

    #-------------------------------------------------------------------------------------------------------------------
    # Create the trip object with the routes (they won't have a path).
    #-------------------------------------------------------------------------------------------------------------------

    pairing.each do |driver, passengers|
      route = RouteContainer.new(nil, driver)

      passengers.each do |passenger|
        route.add_passenger(passenger)
      end

      @trip.add_route(route)
    end

    drivers_going_alone.each do |driver|
      route = RouteContainer.new(nil, driver)
      @trip.add_route(route)
    end

    @trip
  end

  ##
  # Finds the difference of distance of two sides of a triangle subtract the distance of the third side of the triangle.
  # The first two points make up the third line that is the straight line distance and the last point makes up two
  # lines with the first and second vertices.
  #
  # * *Args*    :
  #   - +point1_x+ -> x value for the first point
  #   - +point1_y+ -> y value for the first point
  #   - +point2_x+ -> x value for the second point
  #   - +point2_y+ -> y value for the second point
  #   - +point3_x+ -> x value for the third point
  #   - +point3_y+ -> y value for the third point
  # * *Returns* :
  #   - the difference in distance
  def deviated_distance_from_path(point1_x, point1_y, point2_x, point2_y, point3_x, point3_y)
    straight_line_distance = Math.sqrt((point1_x - point2_x) ** 2 + (point1_y - point2_y) ** 2)
    line1_distance = Math.sqrt((point1_x - point3_x) ** 2 + (point1_y - point3_y) ** 2)
    line2_distance = Math.sqrt((point2_x - point3_x) ** 2 + (point2_y - point3_y) ** 2)

    line1_distance + line2_distance - straight_line_distance
  end

  def straight_line_distance(point1_x, point1_y, point2_x, point2_y)
    Math.sqrt((point1_x - point2_x) ** 2 + (point1_y - point2_y) ** 2)
  end
end