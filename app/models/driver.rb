class Driver < Traveller
  def to_object_container
    DriverContainer.new(self.name, self.email, self.address, self.number_of_passengers)
  end
end