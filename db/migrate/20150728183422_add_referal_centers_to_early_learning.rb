class AddReferalCentersToEarlyLearning < ActiveRecord::Migration
  def change
  	remove_column :early_learning_data, :homeless_public_place

  	add_column :early_learning_data, :referral_key1, :string
  	add_column :early_learning_data, :referral_key2, :string
  	add_column :early_learning_data, :referral_key3, :string

  end
end
