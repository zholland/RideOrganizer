class Trip < ActiveRecord::Base
  has_and_belongs_to_many :travellers
  has_many :routes

  def num_drivers
    i = 0;
    self.travellers.each do |t|
      if t.type == 'Driver'
        i += 1
      end
    end
    return i
  end

  def num_passengers
    i = 0;
    self.travellers.each do |t|
      if t.type == 'Passenger'
        i += 1
      end
    end
    return i
  end

  def to_object_container_no_routes
    trip = TripContainer.new(self.destination_address, self.arrival_time)

    # Add drivers and passengers to trip
    self.travellers.each do |t|
      if t.type == 'Driver'
        trip.add_driver(DriverContainer.new(t.id, t.name, t.email, t.address, t.number_of_passengers))
      else
        trip.add_passenger(PassengerContainer.new(t.id, t.name, t.email, t.address))
      end
    end
    return trip
  end

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
