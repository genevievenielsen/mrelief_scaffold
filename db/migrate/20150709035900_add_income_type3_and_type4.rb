class AddIncomeType3AndType4 < ActiveRecord::Migration
  def change
  	add_column :early_learning_income_cutoffs, :income_type3, :float
  	add_column :early_learning_income_cutoffs, :income_type4, :float
  end
end
