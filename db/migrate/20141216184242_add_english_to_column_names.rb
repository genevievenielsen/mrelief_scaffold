class AddEnglishToColumnNames < ActiveRecord::Migration
  def change
    add_column :programs, :description_en, :string
    add_column :programs, :name_en, :string

    remove_column :programs, :description, :string
    remove_column :programs, :name, :string
  end
end
