class CreateTanifs < ActiveRecord::Migration
  def change
    create_table :tanifs do |t|
      t.integer :household_size
      t.decimal :earned_income
      t.integer :tanif_payment
      t.decimal :max_income

      t.timestamps
    end
  end
end
