class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :age
      t.integer :household_size
      t.decimal :gross_income
      t.string :disability_benefits

      t.timestamps
    end
  end
end
