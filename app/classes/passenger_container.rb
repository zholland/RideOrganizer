class PassengerContainer < TravellerContainer
  def initialize(name, email, address)
    super(name, email, address)
  end

  def to_s
    "#{super.to_s}"
  end
end