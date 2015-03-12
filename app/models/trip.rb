class Trip < ActiveRecord::Base
  serialize :routes
  serialize :passengers
  serialize :drivers

  def passengers=(new_passengers)
    write_attribute(:passengers, new_passengers)
  end

  def routes=(new_routes)
    write_attribute(:routes, new_routes)
  end

  def drivers=(new_drivers)
    write_attribute(:drivers, new_drivers)
  end
end
