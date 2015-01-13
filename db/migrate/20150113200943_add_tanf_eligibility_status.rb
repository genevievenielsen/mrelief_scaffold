class AddTanfEligibilityStatus < ActiveRecord::Migration
  def change
    add_column :tanf_data, :tanf_eligibility_status, :string
  end
end
