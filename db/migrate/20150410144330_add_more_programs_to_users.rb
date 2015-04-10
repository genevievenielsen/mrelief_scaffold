class AddMoreProgramsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :rental_assistance, :string
    add_column :users, :aabd, :string
    add_column :users, :tanf, :string
  end
end
