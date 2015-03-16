class CreateTravellers < ActiveRecord::Migration
  def change
    create_table :travellers do |t|
      t.string :name
      t.string :email
      t.string :address
      t.integer :number_of_passengers
    end
    add_column :travellers, :type, :string
  end
end
