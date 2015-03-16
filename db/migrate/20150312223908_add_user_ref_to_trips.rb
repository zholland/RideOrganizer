class AddUserRefToTrips < ActiveRecord::Migration
  def change
    add_reference :trips, :user, index: true
    add_foreign_key :trips, :users
  end
end
