class CreateChildCareVoucherData < ActiveRecord::Migration
  def change
    create_table :child_care_voucher_data do |t|
      t.string :dependent_no
      t.string :gross_monthly_income
      t.string :user_location
      t.string :zipcode
      t.string :phone_number
      t.string :eligibility_status

      t.timestamps
    end
  end
end
