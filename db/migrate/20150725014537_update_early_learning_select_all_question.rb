class UpdateEarlyLearningSelectAllQuestion < ActiveRecord::Migration
  def change

  	add_column :early_learning_data, :homeless_fixed_residence, :boolean
  	add_column :early_learning_data, :homeless_hotels, :boolean
  	add_column :early_learning_data, :homeless_public_place, :boolean
  	add_column :early_learning_data, :homeless_shelters, :boolean
  	add_column :early_learning_data, :not_homeless, :boolean


  	add_column :early_learning_data, :half_day, :boolean
  	add_column :early_learning_data, :full_day, :boolean
  	add_column :early_learning_data, :part_week, :boolean
  	add_column :early_learning_data, :full_week, :boolean
  	add_column :early_learning_data, :home_visiting, :boolean
  	add_column :early_learning_data, :no_duration_preference, :boolean

  end
end
