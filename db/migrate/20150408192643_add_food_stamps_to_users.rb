class AddFoodStampsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :food_stamps, :string
  end
end
