class AddCategoricalIncomeEligibilityToEarlyLearningTwilio < ActiveRecord::Migration
  def change
  	add_column :early_learning_data_twilios, :foster_temporary_ssi, :boolean, default: false

  end
end
