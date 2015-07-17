class CreateEarlyLearningDataTwilios < ActiveRecord::Migration
  def change
    create_table :early_learning_data_twilios do |t|
      t.string :phone_number
      t.string :children_ages
      t.boolean :no_children
      t.boolean :three_and_under
      t.boolean :three_to_five
      t.boolean :six_to_twelve
      t.boolean :completed
      t.boolean :pregnant
      t.string :zipcode
      t.boolean :foster_homeless_ssi
      t.integer :household_size
      t.float :gross_monthly_income
      t.string :income_type
      t.boolean :employment
      t.boolean :tanf_special_needs
      t.boolean :teen_parent
      t.boolean :completed
      t.boolean :eligible

      t.timestamps
    end
  end
end
