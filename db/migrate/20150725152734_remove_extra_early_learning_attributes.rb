class RemoveExtraEarlyLearningAttributes < ActiveRecord::Migration
  def change
  	remove_column :early_learning_data, :health_status
  	remove_column :early_learning_data, :preferred_frequency
  	remove_column :early_learning_data, :preferred_duration
  	remove_column :early_learning_data, :snap_or_medicaid


  end
end
