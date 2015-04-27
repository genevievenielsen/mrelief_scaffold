class AddWorkAndStudentStatusToAllCity < ActiveRecord::Migration
  def change
    add_column :all_city_program_data, :work_status, :string
    add_column :all_city_program_data, :student_status, :string
  end
end
