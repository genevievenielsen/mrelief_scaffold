class CreatePrograms < ActiveRecord::Migration
  def change
    create_table :programs do |t|
      t.string :name
      t.string :category
      t.string :url
      t.text :description
      t.string :location

      t.timestamps
    end
  end
end
