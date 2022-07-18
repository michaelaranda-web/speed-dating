class AddAssignmentsRefToAttendees < ActiveRecord::Migration[7.0]
  def change
    add_reference :attendees, :assignments, index: false
  end
end
