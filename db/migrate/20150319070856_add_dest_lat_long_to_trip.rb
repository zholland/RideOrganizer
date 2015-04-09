class AddDestLatLongToTrip < ActiveRecord::Migration
  def change
    add_column :trips, :destination_latitude, :decimal
    add_column :trips, :destination_longitude, :decimal
  end
end
