class AddPhoneNumberToAllCityProgramData < ActiveRecord::Migration
  def change
        add_column :all_city_program_data, :phone_number, :string

  end
end
