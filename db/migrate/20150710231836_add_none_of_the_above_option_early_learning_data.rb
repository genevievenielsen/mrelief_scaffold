class AddNoneOfTheAboveOptionEarlyLearningData < ActiveRecord::Migration
  def change
  
  	add_column :early_learning_data, :none_of_the_above, :boolean

  end
end
