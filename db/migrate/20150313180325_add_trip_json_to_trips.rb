class AddTripJsonToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :trip_json, :string
  end
end
