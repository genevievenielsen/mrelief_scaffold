class AddDataSharingToEarlyLearning < ActiveRecord::Migration
  def change
  	add_column :early_learning_data, :data_sharing, :boolean, default: false
  	add_column :early_learning_data_twilios, :data_sharing, :boolean, default: false
  end
end
