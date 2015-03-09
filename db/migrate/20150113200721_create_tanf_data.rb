class CreateTanfData < ActiveRecord::Migration
  def change
    create_table :tanf_data do |t|
      t.string :household_size
      t.string :children
      t.string :thirty_day_gross_income
      t.string :expect_child_support
      t.string :expect_ssi
      t.string :pregnant_or_caring_for_child
      t.string :relationship_to_child
      t.string :enrolled_in_high_school
      t.string :teen_parent
      t.string :pregnant_with_first_child
      t.string :anticipate_other_income
      t.string :tanif_sixty_months
      t.string :citizen
      t.string :zipcode

      t.timestamps
    end
  end
end
