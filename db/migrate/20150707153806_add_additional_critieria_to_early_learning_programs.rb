class AddAdditionalCritieriaToEarlyLearningPrograms < ActiveRecord::Migration
  def change
  	add_column :early_learning_programs, :additional_criteria, :string
  end
end
