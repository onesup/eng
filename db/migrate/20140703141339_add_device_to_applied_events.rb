class AddDeviceToAppliedEvents < ActiveRecord::Migration
  def change
    add_column :applied_events, :device, :string
  end
end
