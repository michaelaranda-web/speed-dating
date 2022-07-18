class CreateAttendees < ActiveRecord::Migration[7.0]
  def change
    create_table :attendees do |t|
      t.string :name
      t.integer :age
      t.string :phone_number
      t.string :gender

      t.timestamps
    end
  end
end
