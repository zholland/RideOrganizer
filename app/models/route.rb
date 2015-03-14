class Route < ActiveRecord::Base
  belongs_to :trip
  has_one :driver
  has_many :passengers

  def to_object_container
    route = RouteContainer.new(self.driver)
    self.passengers.each do |p|
      route.add_passenger(p.to_object_container)
    end
    return route
  end
end