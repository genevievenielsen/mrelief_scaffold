class CreateMedicaidDataTwilios < ActiveRecord::Migration
  def change
    create_table :medicaid_data_twilios do |t|
      t.string :citizen
      t.string :household_size
      t.string :monthly_gross_income
      t.string :zipcode
      t.string :medicaid_eligibility_status
      t.string :phone_number
      t.string :completed

      t.timestamps
    end
  end
end
