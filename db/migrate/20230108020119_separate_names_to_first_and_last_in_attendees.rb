class SeparateNamesToFirstAndLastInAttendees < ActiveRecord::Migration[7.0]
  def change
    rename_column :attendees, :name, :first_name
    add_column :attendees, :last_name, :string
  end
end
