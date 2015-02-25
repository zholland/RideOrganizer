class Trip
  @routes=[]

  attr_accessor :routes, :destination

  def initialize(destination, date)
    @destination=destination
    @date=date
  end

  def addRoute(route)
    @routes << route
  end
end