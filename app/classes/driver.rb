class Driver < Traveller
  attr_accessor :numberOfPassengers

  def initialize(name,email,address,numberOfPassengers)
    super(name,email,address)
    @numberOfPassengers=numberOfPassengers
  end
end