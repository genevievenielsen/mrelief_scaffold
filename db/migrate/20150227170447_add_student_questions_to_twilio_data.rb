class AddStudentQuestionsToTwilioData < ActiveRecord::Migration
  def change
      add_column :snap_eligibility_data_twilios, :enrolled_halftime_or_more, :string
      add_column :snap_eligibility_data_twilios, :work_or_workstudy, :string
  end
end
