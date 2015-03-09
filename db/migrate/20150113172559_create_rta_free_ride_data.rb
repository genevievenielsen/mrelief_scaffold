class CreateRtaFreeRideData < ActiveRecord::Migration
  def change
    create_table :rta_free_ride_data do |t|
      t.string :dependent_no
      t.string :gross_annual_income
      t.string :age
      t.string :disabled_status
      t.string :zipcode
      t.string :rta_eligibility_status

      t.timestamps
    end
  end
end
