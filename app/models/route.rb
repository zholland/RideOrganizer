# Represents a trip route.
class Route < ActiveRecord::Base
  belongs_to :trip
  belongs_to :driver
  has_and_belongs_to_many :travellers

  # Converts the model into a simple Ruby object.
  def to_object_container
    driver = self.driver.nil? ? nil : self.driver.to_object_container
    route = RouteContainer.new(self.id, driver)
    self.travellers.each do |p|
      route.add_passenger(p.to_object_container)
    end
    return route
  end
end