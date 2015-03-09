class CreateRtaFreeRideDataTwilios < ActiveRecord::Migration
  def change
    create_table :rta_free_ride_data_twilios do |t|
      t.string :over_sixty_five
      t.string :disabled
      t.string :disabled_receiving_payments
      t.string :dependent_no
      t.string :zipcode
      t.string :gross_annual_income
      t.string :rta_eligibility_status
      t.boolean :completed
      t.string :phone_number

      t.timestamps
    end
  end
end
