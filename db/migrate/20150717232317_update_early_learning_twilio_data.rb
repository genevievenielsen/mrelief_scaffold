class UpdateEarlyLearningTwilioData < ActiveRecord::Migration
  def change
  	remove_column :early_learning_data_twilios, :eligible

  	add_column :early_learning_data_twilios, :early_learning_eligible, :string
  	add_column :early_learning_data_twilios, :ccap_eligible, :string


  end
end
