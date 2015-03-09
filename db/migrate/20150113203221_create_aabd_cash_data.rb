class CreateAabdCashData < ActiveRecord::Migration
  def change
    create_table :aabd_cash_data do |t|
      t.string :household_size
      t.string :age
      t.string :thirty_day_net_income
      t.string :government_benefits
      t.string :assets
      t.string :citizen
      t.string :disabled_status
      t.string :zipcode
      t.string :aabd_eligibility_status

      t.timestamps
    end
  end
end
