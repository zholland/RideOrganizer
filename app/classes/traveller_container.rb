class TravellerContainer
  attr_accessor :id, :name, :email, :address

  def initialize(id, name, email, address)
    @id = id
    @name = name
    @email = email
    @address = address
  end

  def to_s
    "ID: #{@id}, Name: #{@name}, Email: #{@email}, Address: #{@address}"
  end
end