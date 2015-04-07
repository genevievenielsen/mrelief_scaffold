class AddBenefitsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :benefits, :string
  end
end
