class TripContainer
  attr_accessor :routes, :passengers, :drivers, :date_time, :destination_address, :destination_latitude, :destination_longitude, :driver_passenger_whitelist, :driver_passenger_blacklist

  def initialize(destination_address, date_time)
    @destination_address = destination_address
    @date_time = date_time
    @routes = []
    @passengers = []
    @drivers = []
    @driver_passenger_whitelist = []
    @driver_passenger_blacklist = []
  end

  def add_route(route)
    @routes << route
  end

  def add_passenger(passenger)
    @passengers << passenger
  end

  def add_driver(driver)
    @drivers << driver
  end

  def add_to_whitelist(driver, passenger)
    @driver_passenger_whitelist << [driver, passenger]
  end

  def add_to_blacklist(driver, passenger)
    @driver_passenger_blacklist << [driver, passenger]
  end

  def to_s
    return_string = "\n::::Trip::::\n\nDateTime: #{@date_time}\nDesination: #{@destination_address}"

    @routes.each do |route|
      return_string << "\n#{route.to_s}"
    end

    return_string
  end
end