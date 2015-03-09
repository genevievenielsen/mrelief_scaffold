class AddCompletedToSnapEligibilityDataTwilio < ActiveRecord::Migration
  def change
    add_column :snap_eligibility_data_twilios, :completed, :boolean
  end
end
