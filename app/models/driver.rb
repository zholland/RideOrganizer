class Driver < Traveller
  has_many :routes

  def to_object_container
    DriverContainer.new(self.id, self.name, self.email, self.address, self.number_of_passengers)
  end
end