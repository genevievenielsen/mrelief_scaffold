class CreateEarlyHeadStartData < ActiveRecord::Migration
  def change
    create_table :early_head_start_data do |t|
      t.string :dependent_no
      t.string :gross_monthly_income
      t.string :zipcode
      t.string :user_location
      t.string :phone_number

      t.timestamps
    end
  end
end
