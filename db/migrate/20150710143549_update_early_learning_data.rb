class UpdateEarlyLearningData < ActiveRecord::Migration
  def change
  	add_column :early_learning_data, :income_type, :string

  	add_column :early_learning_data, :snap_or_medicaid, :boolean, default: false
  	add_column :early_learning_data, :health_status, :boolean, default: false
  	add_column :early_learning_data, :teen_parent, :boolean, default: false
  	add_column :early_learning_data, :six_to_twelve, :boolean, default: false
  	add_column :early_learning_data, :special_needs, :boolean, default: false
  	add_column :early_learning_data, :other_zipcode, :boolean, default: false
  	add_column :early_learning_data, :preferred_duration, :string

  	add_column :early_learning_data, :head_start_childcare_collaboration, :boolean, default: false
  	add_column :early_learning_data, :head_start_preschool_childcare_collaboration, :boolean, default: false
  	add_column :early_learning_data, :preschool_for_all_childcare_collaboration, :boolean, default: false
  	add_column :early_learning_data, :prevention_initiative_home_visiting_0to2, :boolean, default: false

  	add_column :early_learning_data, :school_based_no_co_pay_full_day, :boolean, default: false
  	add_column :early_learning_data, :school_based_no_co_pay_half_day, :boolean, default: false
  	add_column :early_learning_data, :school_based_co_pay_full_day, :boolean, default: false
  	add_column :early_learning_data, :school_based_co_pay_half_day, :boolean, default: false
  	add_column :early_learning_data, :head_start_center_based_half_day_3to5, :boolean, default: false
  	add_column :early_learning_data, :early_head_start_childcare_collaboration, :boolean, default: false
  	add_column :early_learning_data, :prevention_initiative_childcare_collaboration, :boolean, default: false
  	add_column :early_learning_data, :early_head_start_home_visiting_0to2, :boolean, default: false
  	add_column :early_learning_data, :head_start_home_visting_3to5, :boolean, default: false
  	add_column :early_learning_data, :head_start_school_based_half_day_3to5, :boolean, default: false
  	add_column :early_learning_data, :head_start_school_based_full_day_3to5, :boolean, default: false
  
  	add_column :early_learning_data, :eligible_count, :integer
  end
end
