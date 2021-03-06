# Represents a general traveller.
class Traveller < ActiveRecord::Base
  has_and_belongs_to_many :trips
  has_and_belongs_to_many :routes

  def self.types
    %w(Driver Passenger)
  end

  # Converts the model into a simple Ruby object.
  def to_object_container
    TravellerContainer.new(self.id, self.name, self.email, self.address)
  end
end