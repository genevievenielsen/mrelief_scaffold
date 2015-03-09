class AddUserLocation < ActiveRecord::Migration
  def change
    add_column :snap_eligibility_data, :user_location, :string
    add_column :rta_free_ride_data, :user_location, :string
    add_column :rental_assistance_data, :user_location, :string
    add_column :all_kids_data, :user_location, :string

    add_column :medicaid_data, :user_location, :string
    add_column :medicare_cost_sharing_data, :user_location, :string
    add_column :aabd_cash_data, :user_location, :string
    add_column :all_city_program_data, :user_location, :string
    add_column :tanf_data, :user_location, :string


  end
end
