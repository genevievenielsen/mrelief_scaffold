class AddStudentQuestionsToFoodStamps < ActiveRecord::Migration
  def change
    add_column :snap_eligibility_data, :work_status, :string
    add_column :snap_eligibility_data, :student_status, :string

  end
end
