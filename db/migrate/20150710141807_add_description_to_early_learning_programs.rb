class AddDescriptionToEarlyLearningPrograms < ActiveRecord::Migration
  def change
  	add_column :early_learning_programs, :description, :string
  end
end
