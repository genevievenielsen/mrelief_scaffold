class AddPhoneNumberToTwilioSnapEligibility < ActiveRecord::Migration
  def change
    add_column :snap_eligibility_data_twilios, :phone_number, :string
  end
end
