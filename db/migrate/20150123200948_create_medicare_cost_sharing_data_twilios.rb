class CreateMedicareCostSharingDataTwilios < ActiveRecord::Migration
  def change
    create_table :medicare_cost_sharing_data_twilios do |t|
      t.string :household_size
      t.string :medicare_household_size
      t.string :monthly_gross_income
      t.string :assets
      t.string :zipcode
      t.string :medicare_cost_sharing_eligibility_status
      t.string :completed
      t.string :phone_number

      t.timestamps
    end
  end
end
