class Traveller < ActiveRecord::Base
  has_and_belongs_to_many :trips

  def self.types
    %w(Driver Passenger)
  end

  def to_object_container
    TravellerContainer.new(self.name, self.email ,self.address)
  end
end