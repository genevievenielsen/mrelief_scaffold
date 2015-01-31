class CreateWicData < ActiveRecord::Migration
  def change
    create_table :wic_data do |t|
      t.string :household_size
      t.string :gross_monthly_income
      t.string :user_location
      t.string :zipcode
      t.string :phone_number
      t.string :eligibility_status

      t.timestamps
    end
  end
end
