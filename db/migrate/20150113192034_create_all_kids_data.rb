class CreateAllKidsData < ActiveRecord::Migration
  def change
    create_table :all_kids_data do |t|
      t.string :household_size
      t.string :monthly_gross_income
      t.string :pregnant
      t.string :healthcare_status
      t.string :zipcode
      t.string :allkids_eligibility_status
      t.string :assist_eligibility
      t.string :share_eligibility
      t.string :premium1_eligibility
      t.string :premium2_eligibility

      t.timestamps
    end
  end
end
