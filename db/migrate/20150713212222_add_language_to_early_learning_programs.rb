class AddLanguageToEarlyLearningPrograms < ActiveRecord::Migration
  def change
  	remove_column :early_learning_data, :higher_education 

  	add_column :early_learning_data, :bilingual, :boolean, default: false

  	add_column :early_learning_data, :bilingual_language, :string
  	add_column :early_learning_data, :preferred_frequency, :string
  end
end
