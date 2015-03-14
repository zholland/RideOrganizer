class AddDriverRefToRoutes < ActiveRecord::Migration
  def change
    add_reference :routes, :driver, index: true
    add_foreign_key :routes, :travellers
  end
end
