class Passenger < Traveller
  def to_object_container
    PassengerContainer.new(self.name, self.email, self.address)
  end
end