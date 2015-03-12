class AddRoutesDriversPassengersToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :routes, :Route
    add_column :trips, :passengers, :Passenger
    add_column :trips, :drivers, :Driver
  end
end
