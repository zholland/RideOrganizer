class CreateTravellers < ActiveRecord::Migration
  def change
    create_table :travellers do |t|
      t.string :name
      t.string :email
      t.string :address

      t.timestamps null: false
    end
  end
end
