# Represents a trip.
class Trip < ActiveRecord::Base
  has_and_belongs_to_many :travellers
  has_many :routes

  # Returns the number of drivers on the trip.
  def num_drivers
    i = 0;
    self.travellers.each do |t|
      if t.type == 'Driver'
        i += 1
      end
    end
    return i
  end

  # Returns the number of passenger on the trip.
  def num_passengers
    i = 0;
    self.travellers.each do |t|
      if t.type == 'Passenger'
        i += 1
      end
    end
    return i
  end

  # Converts the model into a simple Ruby object. Does not include the existing trip routes.
  def to_object_container_no_routes
    trip = TripContainer.new(self.destination_address, self.arrival_time)
    trip.destination_latitude = destination_latitude
    trip.destination_longitude = destination_longitude

    # Add drivers and passengers to trip
    self.travellers.each do |t|
      if t.type == 'Driver'
        driver = DriverContainer.new(t.id, t.name, t.email, t.address, t.number_of_passengers)
        driver.latitude = t.latitude
        driver.longitude = t.longitude
        trip.add_driver(driver)
      else
        passenger = PassengerContainer.new(t.id, t.name, t.email, t.address)
        passenger.latitude = t.latitude
        passenger.longitude = t.longitude
        trip.add_passenger(passenger)
      end
    end

    return trip
  end

  # Creates a json string containing the traveller ids.
  def travellers_ids_to_json
    json = {drivers: [], passengers: []}
    self.travellers.each do |t|
      if t.type == 'Driver'
        json[:drivers] << t.id
      else
        json[:passengers] << t.id
      end
    end
    puts json.to_json
    json.to_json
  end

  # Create the trip routes from a given trip object container
  def create_routes_from_trip_object(trip_object)
    trip_object.routes.each do |r|
      driver = Driver.find(r.driver.id)
      route = Route.create(driver: driver)
      r.id = route.id
      r.passengers.each do |p|
            route.travellers << Traveller.find(p.id)
      end
      self.routes << route
    end
  end

end
