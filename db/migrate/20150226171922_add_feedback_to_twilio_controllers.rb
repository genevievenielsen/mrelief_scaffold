class AddFeedbackToTwilioControllers < ActiveRecord::Migration
  def change
    add_column :snap_eligibility_data_twilios, :feedback, :string
    add_column :medicaid_data_twilios, :feedback, :string
    add_column :medicare_cost_sharing_data_twilios, :feedback, :string
    add_column :rta_free_ride_data_twilios, :feedback, :string
  end
end
