class CreateMedicaidData < ActiveRecord::Migration
  def change
    create_table :medicaid_data do |t|
      t.string :household_size
      t.string :monthly_gross_income
      t.string :citizen
      t.string :zipcode
      t.string :medicaid_eligibility_status

      t.timestamps
    end
  end
end
