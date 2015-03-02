class Passenger < Traveller
  def initialize(name, email, address)
    super(name, email, address)
  end

  def to_s
    "#{super.to_s}"
  end
end