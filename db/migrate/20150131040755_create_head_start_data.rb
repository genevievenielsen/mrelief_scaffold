class CreateHeadStartData < ActiveRecord::Migration
  def change
    create_table :head_start_data do |t|
      t.string :dependent_no
      t.string :gross_annual_income
      t.string :child_birthdate
      t.string :zipcode
      t.string :user_location
      t.string :phone_number
      t.string :eligibility_status

      t.timestamps
    end
  end
end
