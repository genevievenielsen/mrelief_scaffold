class UpdateDataTypesEarlyLearningData < ActiveRecord::Migration
  def change
  	remove_column :early_learning_data, :other_zipcode
  	add_column :early_learning_data, :other_zipcode, :string


  end
end
