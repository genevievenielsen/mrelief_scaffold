class AddDurationToEarlyLearningPrograms < ActiveRecord::Migration
  def change
  	add_column :early_learning_programs, :duration, :string
  end
end
