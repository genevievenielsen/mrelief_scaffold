class CreateEarlyLearningDataTwilios < ActiveRecord::Migration
  def change
    create_table :early_learning_data_twilios do |t|
      t.string :phone_number
      t.string :children_ages
      t.boolean :no_children, default: false
      t.boolean :three_and_under, default: false
      t.boolean :three_to_five, default: false
      t.boolean :six_to_twelve, default: false
      t.boolean :completed, default: false
      t.boolean :pregnant, default: false
      t.string :zipcode
      t.boolean :foster_homeless_ssi, default: false
      t.integer :household_size
      t.float :gross_monthly_income
      t.string :income_type
      t.boolean :employment, default: false
      t.boolean :tanf_special_needs, default: false
      t.boolean :teen_parent, default: false
      t.boolean :completed, default: false
      t.boolean :eligible, default: false

      t.timestamps
    end
  end
end
