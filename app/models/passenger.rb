# Represents a passenger.
class Passenger < Traveller
  # Converts the model into a simple Ruby object.
  def to_object_container
    PassengerContainer.new(self.id, self.name, self.email, self.address)
  end
end