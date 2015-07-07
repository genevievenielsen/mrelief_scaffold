class CreateEarlyLearningData < ActiveRecord::Migration
  def change
    create_table :early_learning_data do |t|
      t.boolean :three_and_under, default: false
      t.boolean :three_to_five, default: false
      t.boolean :pregnant, default: false
      t.boolean :no_children, default: false
      t.integer :household_size
      t.float :gross_monthly_income
      t.boolean :foster_parent, default: false
      t.boolean :homeless, default: false
      t.boolean :ssi, default: false
      t.boolean :tanf, default: false
      t.boolean :employed
      t.boolean :higher_education
      t.string :zipcode
      t.string :preferred_zipcode
      t.string :phone_number

      t.timestamps
    end
  end
end
