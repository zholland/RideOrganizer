class PassengerContainer < TravellerContainer
  def initialize(id, name, email, address)
    super(id, name, email, address)
  end

  def to_s
    "#{super.to_s}"
  end
end