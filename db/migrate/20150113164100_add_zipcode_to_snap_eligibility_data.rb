class AddZipcodeToSnapEligibilityData < ActiveRecord::Migration
  def change
    add_column :snap_eligibility_data, :zipcode, :string
  end
end
