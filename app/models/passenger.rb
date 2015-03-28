class Passenger < Traveller
  has_and_belongs_to_many :routes

  def to_object_container
    PassengerContainer.new(self.id, self.name, self.email, self.address)
  end
end