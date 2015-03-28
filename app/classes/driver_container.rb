require_relative 'traveller_container'

class DriverContainer < TravellerContainer
  attr_accessor :number_of_passengers

  def initialize(id, name, email, address, number_of_passengers)
    super(id, name, email, address)
    @number_of_passengers = number_of_passengers
  end

  def to_s
    "#{super.to_s}, NumberOfPassengers: #{@number_of_passengers}"
  end
end