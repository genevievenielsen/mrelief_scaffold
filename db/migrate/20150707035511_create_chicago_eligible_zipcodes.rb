class CreateChicagoEligibleZipcodes < ActiveRecord::Migration
  def change
    create_table :chicago_eligible_zipcodes do |t|
      t.string :zipcode

      t.timestamps
    end
  end
end
