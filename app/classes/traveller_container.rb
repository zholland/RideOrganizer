class TravellerContainer
  attr_accessor :name, :email, :address

  def initialize(name, email, address)
    @name = name
    @email = email
    @address = address
  end

  def to_s
    "Name: #{@name}, Email: #{@email}, Address: #{@address}"
  end
end