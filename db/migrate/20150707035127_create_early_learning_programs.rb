class CreateEarlyLearningPrograms < ActiveRecord::Migration
  def change
    create_table :early_learning_programs do |t|
      t.string :agency
      t.string :funder
      t.string :site
      t.string :ages_served
      t.string :income_type

      t.timestamps
    end
  end
end
