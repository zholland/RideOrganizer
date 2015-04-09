class AddLatLongToTraveller < ActiveRecord::Migration
  def change
    add_column :travellers, :latitude, :float
    add_column :travellers, :longitude, :float
  end
end
