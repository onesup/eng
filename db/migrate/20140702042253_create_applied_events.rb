class CreateAppliedEvents < ActiveRecord::Migration
  def change
    create_table :applied_events do |t|
      t.string :title
      t.references :user, index: true

      t.timestamps
    end
  end
end
