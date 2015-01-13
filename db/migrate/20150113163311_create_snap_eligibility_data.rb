class CreateSnapEligibilityData < ActiveRecord::Migration
  def change
    create_table :snap_eligibility_data do |t|
      t.string :dependent_no
      t.string :age
      t.string :monthly_gross_income
      t.string :citizen
      t.string :enrolled_in_education
      t.string :disabled_status
      t.string :snap_eligibility_status

      t.timestamps
    end
  end
end
