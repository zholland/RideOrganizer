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

  def to_object_container
    trip = TripContainer.new(self.destination_address, self.arrival_time)

    # Add routes to trip
    self.routes.each do |r|
      trip.add_route(r.to_object_container)
    end

    # Add drivers and passengers to trip
    self.travellers.each do |t|
      if t.type == 'Driver'
        trip.add_driver(DriverContainer.new(t.name, t.email, t.address, t.number_of_passengers))
      else
        trip.add_passenger(PassengerContainer.new(t.name, t.email, t.address))
      end
    end
    return trip
  end
end
