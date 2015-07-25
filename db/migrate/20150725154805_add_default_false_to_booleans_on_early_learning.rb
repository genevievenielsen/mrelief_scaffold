class AddDefaultFalseToBooleansOnEarlyLearning < ActiveRecord::Migration
  def change
  	remove_column :early_learning_data, :homeless_fixed_residence, :boolean
  	remove_column :early_learning_data, :homeless_hotels, :boolean
  	remove_column :early_learning_data, :homeless_public_place, :boolean
  	remove_column :early_learning_data, :homeless_shelters, :boolean
  	remove_column :early_learning_data, :not_homeless, :boolean


  	remove_column :early_learning_data, :half_day, :boolean
  	remove_column :early_learning_data, :full_day, :boolean
  	remove_column :early_learning_data, :part_week, :boolean
  	remove_column :early_learning_data, :full_week, :boolean
  	remove_column :early_learning_data, :home_visiting, :boolean
  	remove_column :early_learning_data, :no_duration_preference, :boolean


  	add_column :early_learning_data, :homeless_fixed_residence, :boolean, default: false
  	add_column :early_learning_data, :homeless_hotels, :boolean, default: false
  	add_column :early_learning_data, :homeless_public_place, :boolean, default: false
  	add_column :early_learning_data, :homeless_shelters, :boolean, default: false
  	add_column :early_learning_data, :not_homeless, :boolean, default: false


  	add_column :early_learning_data, :half_day, :boolean, default: false
  	add_column :early_learning_data, :full_day, :boolean, default: false
  	add_column :early_learning_data, :part_week, :boolean, default: false
  	add_column :early_learning_data, :full_week, :boolean, default: false
  	add_column :early_learning_data, :home_visiting, :boolean, default: false
  	add_column :early_learning_data, :no_duration_preference, :boolean, default: false
  end
end
