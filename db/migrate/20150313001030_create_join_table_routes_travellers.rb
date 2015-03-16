class CreateJoinTableRoutesTravellers < ActiveRecord::Migration
  def change
    create_join_table :routes, :travellers do |t|
      # t.index [:route_id, :traveller_id]
      # t.index [:traveller_id, :route_id]
    end
  end
end
