class UpdateEarlyLearningDataTwilioAgain < ActiveRecord::Migration
  def change
  	remove_column :early_learning_data_twilios, :early_learning_eligible, :string
  	remove_column :early_learning_data_twilios, :ccap_eligible, :string

  	add_column :early_learning_data_twilios, :early_learning_eligible, :boolean, default: false
  	add_column :early_learning_data_twilios, :ccap_eligible, :boolean, default: false

  end
end
