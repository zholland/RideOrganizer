require_relative 'traveller'

class Driver < Traveller
  attr_accessor :number_of_passengers

  def initialize(name, email, address, number_of_passengers)
    super(name, email, address)
    @number_of_passengers = number_of_passengers
  end

  def to_s
    "#{super.to_s}, NumberOfPassengers: #{@number_of_passengers}"
  end
end