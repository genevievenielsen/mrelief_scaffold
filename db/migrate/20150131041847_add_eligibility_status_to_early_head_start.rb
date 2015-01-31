class AddEligibilityStatusToEarlyHeadStart < ActiveRecord::Migration
  def change
    add_column :early_head_start_data, :eligibility_status, :string
  end
end
