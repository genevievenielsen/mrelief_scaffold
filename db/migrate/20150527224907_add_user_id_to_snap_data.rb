class AddUserIdToSnapData < ActiveRecord::Migration
  def change
    add_column :snap_eligibility_data, :user_id, :integer
  end
end
