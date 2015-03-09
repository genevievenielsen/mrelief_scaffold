class CreateRentalAssistanceData < ActiveRecord::Migration
  def change
    create_table :rental_assistance_data do |t|
      t.string :dependent_no
      t.string :ninety_day_gross_income
      t.string :name_on_lease
      t.string :rental_status
      t.string :zipcode
      t.string :rental_eligibility_status

      t.timestamps
    end
  end
end
