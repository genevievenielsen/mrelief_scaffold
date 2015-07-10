class UpdateChildCareVoucher < ActiveRecord::Migration
  def change
  	add_column :child_care_voucher_data, :teen_parent, :boolean, default: false
  	add_column :child_care_voucher_data, :special_needs, :boolean, default: false
  	add_column :child_care_voucher_data, :tanf, :boolean, default: false

  	add_column :child_care_voucher_data, :child, :boolean, default: false
  	add_column :child_care_voucher_data, :employed, :boolean, default: false

  	add_column :early_learning_data, :wic_eligible, :boolean, default: false
  	add_column :early_learning_data, :ccap_eligible, :boolean, default: false

  	

  end
end
