class AddCompleteToEarlyLearningWebAndSpanishToText < ActiveRecord::Migration
  def change
  	add_column :early_learning_data, :complete, :boolean, default: false
  	add_column :early_learning_data, :spanish, :boolean, default: false

  	add_column :early_learning_data_twilios, :spanish, :boolean, default: false

  end
end
