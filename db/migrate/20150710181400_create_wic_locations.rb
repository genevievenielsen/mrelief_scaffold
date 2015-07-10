class CreateWicLocations < ActiveRecord::Migration
  def change
    create_table :wic_locations do |t|
      t.string :address
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :phone_number

      t.timestamps
    end
  end
end
