class AddPhoneNumberToForms < ActiveRecord::Migration
  def change
    add_column :snap_eligibility_data, :phone_number, :string
    add_column :rta_free_ride_data, :phone_number, :string
    add_column :rental_assistance_data, :phone_number, :string
    add_column :all_kids_data, :phone_number, :string

    add_column :medicaid_data, :phone_number, :string
    add_column :medicare_cost_sharing_data, :phone_number, :string
    add_column :aabd_cash_data, :phone_number, :string
    add_column :tanf_data, :phone_number, :string
  end
end
