class Route
  @passengers=[]

  attr_accessor :passengers, :driver

  def initialize(driver)
    @driver=driver
  end

  def addPassenger(passenger)
    @passengers << passenger
  end
end