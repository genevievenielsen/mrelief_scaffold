class AddHealthStatusToWicData < ActiveRecord::Migration
  def change
    add_column :wic_data, :health_status, :string
  end
end
