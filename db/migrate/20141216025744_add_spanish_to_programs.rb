class AddSpanishToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :description_es, :string
    add_column :programs, :name_es, :string
  end
end
