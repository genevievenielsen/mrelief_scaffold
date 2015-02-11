class AddNextMonthNextQuestion < ActiveRecord::Migration
  def change
    add_column :rental_assistance_data, :next_month_rent, :string
    add_column :all_city_program_data, :next_month_rent, :string

  end
end
