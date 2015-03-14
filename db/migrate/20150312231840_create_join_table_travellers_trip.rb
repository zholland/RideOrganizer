class CreateJoinTableTravellersTrip < ActiveRecord::Migration
  def change
    create_join_table :trips, :travellers do |t|
      # t.index [:trip_id, :traveller_id]
      # t.index [:traveller_id, :trip_id]
    end
  end
end
