class AddDriveridToDrivers < ActiveRecord::Migration
  def change
    add_column :drivers, :driverid, :int
    execute "CREATE SEQUENCE drivers_driverid_seq START 1"
  end
end
