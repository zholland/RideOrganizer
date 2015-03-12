# class Trip
#   attr_accessor :routes, :passengers, :drivers, :date_time, :destination_address
#
#   def initialize(destination_address, date_time)
#     @destination_address = destination_address
#     @date_time = date_time
#     @routes = []
#     @passengers = []
#     @drivers = []
#   end
#
#   def add_route(route)
#     @routes << route
#   end
#
#   def add_passenger(passenger)
#     @passengers << passenger
#   end
#
#   def add_driver(driver)
#     @drivers << driver
#   end
#
#   def to_s
#     return_string = "\n::::Trip::::\n\nDateTime: #{@date_time}\nDesination: #{@destination_address}"
#
#     @routes.each do |route|
#       return_string << "\n#{route.to_s}"
#     end
#
#     return_string
#   end
# end