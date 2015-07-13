class ChangeDataTypeOfBilingual < ActiveRecord::Migration
  def change
  	remove_column :early_learning_data, :bilingual
  	add_column :early_learning_data, :bilingual, :string
  end
end
