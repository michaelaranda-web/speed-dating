class RemoveAssignmentsIdFromAttendees < ActiveRecord::Migration[7.0]
  def change
    remove_column :attendees, :assignments_id
  end
end
