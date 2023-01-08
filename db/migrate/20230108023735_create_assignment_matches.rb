class CreateAssignmentMatches < ActiveRecord::Migration[7.0]
  def change
    create_table :assignment_matches do |t|
      t.integer :assignment_id, null: false
      t.integer :round, null: false
      t.integer :male_attendee_id
      t.integer :female_attendee_id
      t.boolean :is_mingler, null:false, default: false
      t.timestamps
    end
  end
end
