class CreateExclusions < ActiveRecord::Migration[7.0]
  def change
    create_table :exclusions do |t|
      t.integer "male_attendee_id", null: false
      t.integer "female_attendee_id", null: false
      t.timestamps
    end
  end
end
