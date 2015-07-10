class UpdateEarlyLearningDataAgain < ActiveRecord::Migration
  def change

  	  remove_column :early_learning_data, :employed
  	  remove_column :early_learning_data, :higher_education
  	  remove_column :early_learning_data, :health_status

  	  add_column :early_learning_data, :employed, :string
  	  add_column :early_learning_data, :higher_education, :string
  	  add_column :early_learning_data, :health_status, :string


  end
end
