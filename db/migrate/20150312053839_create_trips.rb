class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.string :destination_address
      t.datetime :date_time

      t.timestamps null: false
    end
  end
end
