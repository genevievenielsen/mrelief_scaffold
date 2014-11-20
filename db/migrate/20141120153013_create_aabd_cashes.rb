class CreateAabdCashes < ActiveRecord::Migration
  def change
    create_table :aabd_cashes do |t|

      t.timestamps
    end
  end
end
