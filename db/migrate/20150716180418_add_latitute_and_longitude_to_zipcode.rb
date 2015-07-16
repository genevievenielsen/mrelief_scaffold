class AddLatituteAndLongitudeToZipcode < ActiveRecord::Migration
  def change
  	add_column :chicago_eligible_zipcodes, :latitude, :float
  	add_column :chicago_eligible_zipcodes, :longitude, :float
  end
end
