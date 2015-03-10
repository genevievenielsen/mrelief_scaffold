class AddCashInAccountToSnap < ActiveRecord::Migration
  def change
    add_column :snap_eligibility_data, :amount_in_account, :string
  end
end
