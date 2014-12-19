class CreateAllCityProgramData < ActiveRecord::Migration
  def change
    create_table :all_city_program_data do |t|
      t.integer :dependent_no
      t.integer :medicare_household_size
      t.integer :age
      t.integer :monthly_gross_income
      t.integer :thirty_day_net_income
      t.integer :child_support
      t.integer :ssi
      t.integer :monthly_benefits
      t.integer :ninety_day_gross_income
      t.integer :annual_gross_income
      t.integer :assets
      t.integer :number_of_children
      t.string :enrolled_in_education
      t.string :citizen
      t.string :zipcode
      t.string :disabled_status
      t.string :name_on_lease
      t.string :rental_status
      t.string :pregnant
      t.string :child_health_insurance_state
      t.string :pregnant_or_caring_for_child
      t.string :relationship_to_child
      t.string :pregnant_with_first_child
      t.string :tanif_sixty_months
      t.string :anticipate_other_income
      t.string :teen_parent
      t.string :child_in_school
      t.string :snap_eligibility_status
      t.string :all_kids_eligibility_status
      t.string :rta_eligibility_status
      t.string :medicaid_eligibility_status
      t.string :medicare_cost_sharing_eligibility_status
      t.string :rental_eligibility_status
      t.string :aabd_eligibility_status
      t.string :tanf_eligibility_status

      t.timestamps
    end
  end
end
