class AddOtherProgramsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :rta_ride_free, :string
    add_column :users, :medicaid, :string
    add_column :users, :medicare_cost_sharing, :string
    add_column :users, :all_kids, :string
    add_column :users, :child_care_vouchers, :string
    add_column :users, :wic, :string
    add_column :users, :early_head_start, :string
    add_column :users, :head_start, :string
  end
end
