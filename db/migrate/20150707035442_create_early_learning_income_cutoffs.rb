class CreateEarlyLearningIncomeCutoffs < ActiveRecord::Migration
  def change
    create_table :early_learning_income_cutoffs do |t|
      t.integer :household_size
      t.float :income_type1
      t.float :income_type2

      t.timestamps
    end
  end
end
