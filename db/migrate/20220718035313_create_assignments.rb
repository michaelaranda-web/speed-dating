class CreateAssignments < ActiveRecord::Migration[7.0]
  def change
    create_table :assignments do |t|
      t.integer :num_tables
      t.integer :num_rounds

      t.timestamps
    end
  end
end
