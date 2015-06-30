class CreateDrivers < ActiveRecord::Migration
  def change
    create_table :drivers do |t|
      t.string :email
      t.time :time
      t.point :sourceposition
      t.point :destinationposition

      t.timestamps null: false
    end
  end
end
