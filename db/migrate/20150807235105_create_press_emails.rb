class CreatePressEmails < ActiveRecord::Migration
  def change
    create_table :press_emails do |t|
      t.string :publication_name
      t.string :author_name
      t.string :email

      t.timestamps
    end
  end
end
