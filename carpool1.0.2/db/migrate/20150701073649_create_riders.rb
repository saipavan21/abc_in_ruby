class CreateRiders < ActiveRecord::Migration
  def change
    create_table :riders do |t|
      t.string :email
      t.time :time
      t.float :sourcelat
      t.float :sourcelong
      t.float :deslat
      t.float :deslong

      t.timestamps null: false
    end
  end
end
