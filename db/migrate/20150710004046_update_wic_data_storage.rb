class UpdateWicDataStorage < ActiveRecord::Migration
  def change
  	add_column :wic_data, :pregnant_or_child, :string
  	add_column :wic_data, :snap_tanf_medicaid, :string
  end
end
