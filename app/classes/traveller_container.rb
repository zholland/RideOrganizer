class TravellerContainer
  attr_accessor :id, :name, :email, :address, :latitude, :longitude

  def initialize(id, name, email, address)
    @id = id
    @name = name
    @email = email
    @address = address
  end

  def to_s
    "ID: #{@id}, Name: #{@name}, Email: #{@email}, Address: #{@address}, Latitude: " << ((self.latitude.nil?) ? '' : self.latitude.to_s) << ", Longitude: " << ((self.longitude.nil?) ? '' : self.longitude.to_s)
  end
end