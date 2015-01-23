class CreateSnapEligibilityDataTwilios < ActiveRecord::Migration
  def change
    create_table :snap_eligibility_data_twilios do |t|
      t.string :citizen
      t.string :enrolled_in_education
      t.string :zipcode
      t.string :age
      t.string :dependent_no
      t.string :disabled
      t.string :disabled_receiving_payment
      t.string :monthly_gross_income
      t.string :snap_eligibility_status

      t.timestamps
    end
  end
end
