class Route
  attr_accessor :passengers, :driver

  def initialize(driver)
    @driver = driver
    @passengers = []
  end

  def add_passenger(passenger)
    @passengers << passenger
  end

  def to_s
    return_string = "Driver: #{@driver.to_s}\nPassengers:"

    @passengers.each() do |passenger|
      return_string << "\n\t#{passenger.to_s}"
    end

    return_string
  end
end