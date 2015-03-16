class AddTripRefToRoutes < ActiveRecord::Migration
  def change
    add_reference :routes, :trip, index: true
    add_foreign_key :routes, :trips
  end
end
